function [logger, treeAgents] = runFireVisualization(treeAgents, p)
% RUNFIREVISUALIZATION Runs the fire simulation with a live dashboard and
% logs population metrics over time.
%
%   [logger, treeAgents] = runFireVisualization(treeAgents, p)
%
%   Inputs
%     treeAgents - 2D array of TreeAgent objects (handle class), with the
%                  initial fire(s) already ignited
%     p          - struct of parameters:
%         .gridSize           (required) forest grid dimension
%         .interactionRadius  (required)
%         .baseIgnitionProb   (required)
%         .windVector         (required) 1x2 [WindX, WindY]
%         .maxSteps           default 300
%         .pauseTime          default 0.05 seconds between frames
%         .csvName            default '' (set e.g. 'fire_log.csv' to save)
%         .videoName          default '' (set e.g. 'fire.mp4' to record)
%
%   Outputs
%     logger     - FireLogger holding every metric (use toTable / summary)
%     treeAgents - final state of the forest
%
%   Example
%     p.gridSize = 50; p.interactionRadius = 2; p.baseIgnitionProb = 0.6;
%     p.windVector = [1 0]; p.csvName = 'fire_log.csv';
%     [logger, agents] = runFireVisualization(agents, p);
%     disp(logger.summary());

    if ~isfield(p, 'maxSteps'),  p.maxSteps = 300;    end
    if ~isfield(p, 'pauseTime'), p.pauseTime = 0.05;  end
    if ~isfield(p, 'csvName'),   p.csvName = '';      end
    if ~isfield(p, 'videoName'), p.videoName = '';    end

    logger = FireLogger();

    % ---- Initial frame ----
    S = agentsToStateMatrix(treeAgents);
    totalTrees = sum(S(:) > 0);
    viz = FireVisualizer(S, totalTrees);
    if ~isempty(p.videoName)
        viz.startVideo(p.videoName);
    end

    % ---- Simulation loop ----
    for t = 0:p.maxSteps
        S = agentsToStateMatrix(treeAgents);
        logger.record(t, S);
        viz.update(S, logger, t);

        if ~any(S(:) == 2)          % fire is out
            break;
        end

        treeAgents = updateFireDynamics(treeAgents, p.gridSize, ...
            p.interactionRadius, p.baseIgnitionProb, p.windVector);

        if p.pauseTime > 0
            pause(p.pauseTime);
        end
    end

    viz.finish();

    % ---- Report ----
    s = logger.summary();
    fprintf(['Fire out after %d steps. Peak burning: %d trees (step %d). ' ...
             '%.1f%% of the forest affected.\n'], ...
            s.Duration, s.PeakBurning, s.StepOfPeakBurning, s.PercentAffected);

    if ~isempty(p.csvName)
        logger.saveCSV(p.csvName);
        fprintf('Metrics saved to %s\n', p.csvName);
    end
end
