classdef FireVisualizer < handle
% FIREVISUALIZER Real-time dashboard for the forest fire simulation.
%
%   viz = FireVisualizer(S0, totalTrees);        % S0 = initial state matrix
%   viz.update(S, logger, t);                    % call every time step
%   viz.finish();                                % close video file if any
%
%   Layout
%     Left          imagesc grid:  white = empty, green = healthy,
%                                  orange = burning, dark grey = burnt
%     Top right     population dynamics: healthy / burning / burnt counts
%     Bottom right  new ignitions per step (left axis) and percentage of
%                   the forest affected (right axis)
%
%   Optional: viz.startVideo('fire.mp4') records every frame to a video.
%
%   Note: imagesc draws the matrix as stored, so row index (treeAgents(x,y)
%   first index) runs top to bottom and column index runs left to right.

    properties
        Fig
        AxGrid
        Img
        Title
        AxCounts
        LnHealthy
        LnBurning
        LnBurnt
        AxRate
        LnIgnitions
        LnPercent
        TotalTrees
        Video = []
    end

    methods
        function obj = FireVisualizer(S0, totalTrees)
            obj.TotalTrees = max(totalTrees, 1);

            cmap = [1.00 1.00 1.00;     % 0 empty
                    0.13 0.55 0.13;     % 1 healthy
                    1.00 0.35 0.00;     % 2 burning
                    0.20 0.20 0.20];    % 3 burnt
            cGreen = cmap(2, :); cRed = cmap(3, :); cGrey = cmap(4, :);

            obj.Fig = figure('Name', 'Forest Fire Simulation', 'Color', 'w', ...
                             'Position', [100 100 1200 600]);

            % ---- Left: animated grid ----
            obj.AxGrid = subplot(2, 2, [1 3]);
            obj.Img = imagesc(obj.AxGrid, S0, [0 3]);
            colormap(obj.AxGrid, cmap);
            axis(obj.AxGrid, 'image');
            set(obj.AxGrid, 'XTick', [], 'YTick', []);
            obj.Title = title(obj.AxGrid, 'Step 0');

            % ---- Top right: population dynamics ----
            obj.AxCounts = subplot(2, 2, 2);
            hold(obj.AxCounts, 'on'); grid(obj.AxCounts, 'on');
            obj.LnHealthy = plot(obj.AxCounts, NaN, NaN, 'Color', cGreen, 'LineWidth', 2);
            obj.LnBurning = plot(obj.AxCounts, NaN, NaN, 'Color', cRed,   'LineWidth', 2);
            obj.LnBurnt   = plot(obj.AxCounts, NaN, NaN, 'Color', cGrey,  'LineWidth', 2);
            xlabel(obj.AxCounts, 'Time step'); ylabel(obj.AxCounts, 'Number of trees');
            title(obj.AxCounts, 'Population dynamics');
            legend(obj.AxCounts, [obj.LnHealthy obj.LnBurning obj.LnBurnt], ...
                   {'Healthy', 'Burning', 'Burnt'}, 'Location', 'east');
            ylim(obj.AxCounts, [0 obj.TotalTrees * 1.05]);

            % ---- Bottom right: ignition rate and percent affected ----
            obj.AxRate = subplot(2, 2, 4);
            grid(obj.AxRate, 'on');
            yyaxis(obj.AxRate, 'left');
            obj.LnIgnitions = plot(obj.AxRate, NaN, NaN, 'Color', cRed, 'LineWidth', 2);
            ylabel(obj.AxRate, 'New ignitions per step');
            yyaxis(obj.AxRate, 'right');
            hold(obj.AxRate, 'on');
            obj.LnPercent = plot(obj.AxRate, NaN, NaN, 'Color', [0 0.45 0.74], 'LineWidth', 2);
            ylabel(obj.AxRate, '% of forest affected'); ylim(obj.AxRate, [0 100]);
            xlabel(obj.AxRate, 'Time step');
            title(obj.AxRate, 'Spread rate and extent');
            legend(obj.AxRate, [obj.LnIgnitions obj.LnPercent], ...
                   {'New ignitions', '% affected'}, 'Location', 'north');

            drawnow;
        end

        function startVideo(obj, filename)
            obj.Video = VideoWriter(filename, 'MPEG-4');
            obj.Video.FrameRate = 10;
            open(obj.Video);
        end

        function update(obj, S, logger, t)
            % Grid
            set(obj.Img, 'CData', S);

            % Time series (redrawn from the logger's full history)
            set(obj.LnHealthy,   'XData', logger.Step, 'YData', logger.Healthy);
            set(obj.LnBurning,   'XData', logger.Step, 'YData', logger.Burning);
            set(obj.LnBurnt,     'XData', logger.Step, 'YData', logger.Burnt);
            set(obj.LnIgnitions, 'XData', logger.Step, 'YData', logger.NewIgnitions);
            set(obj.LnPercent,   'XData', logger.Step, 'YData', logger.fractionAffected());
            xl = [0 max(10, t)];
            xlim(obj.AxCounts, xl);
            xlim(obj.AxRate, xl);

            set(obj.Title, 'String', sprintf('Step %d  |  healthy %d  |  burning %d  |  burnt %d', ...
                t, logger.Healthy(end), logger.Burning(end), logger.Burnt(end)));

            drawnow limitrate;

            if ~isempty(obj.Video) && isvalid(obj.Video)
                writeVideo(obj.Video, getframe(obj.Fig));
            end
        end

        function finish(obj)
            drawnow;
            if ~isempty(obj.Video) && isvalid(obj.Video)
                close(obj.Video);
                obj.Video = [];
            end
        end
    end
end
