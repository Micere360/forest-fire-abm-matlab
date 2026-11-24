classdef FireLogger < handle
% FIRELOGGER Tracks and logs population metrics for the forest fire model.
%
%   logger = FireLogger();
%   logger.record(t, S);          % S = agentsToStateMatrix(treeAgents)
%   T = logger.toTable();         % MATLAB table of every metric over time
%   s = logger.summary();         % struct of headline results
%   logger.saveCSV('fire_log.csv');
%
%   Logged each step: Healthy, Burning, Burnt, Empty counts, NewIgnitions
%   (healthy -> burning transitions since the previous record; at the first
%   record it equals the initial fires), and the fractions of the forest.

    properties (SetAccess = private)
        Step        = []   % time step numbers
        Healthy     = []   % number of healthy trees
        Burning     = []   % number of burning trees
        Burnt       = []   % number of burnt trees
        Empty       = []   % number of empty / non-tree cells
        NewIgnitions = []  % trees that caught fire this step
        TotalTrees  = 0    % trees in the forest at the start (non-empty cells)
    end

    properties (Access = private)
        PrevState = []     % previous state matrix, to detect new ignitions
    end

    methods
        function record(obj, step, S)
            nHealthy = sum(S(:) == 1);
            nBurning = sum(S(:) == 2);
            nBurnt   = sum(S(:) == 3);
            nEmpty   = sum(S(:) == 0);

            if isempty(obj.PrevState)
                obj.TotalTrees = numel(S) - nEmpty;
                newIg = nBurning;                      % initial fires
            else
                newIg = sum(obj.PrevState(:) == 1 & S(:) == 2);
            end

            obj.Step(end+1, 1)         = step;
            obj.Healthy(end+1, 1)      = nHealthy;
            obj.Burning(end+1, 1)      = nBurning;
            obj.Burnt(end+1, 1)        = nBurnt;
            obj.Empty(end+1, 1)        = nEmpty;
            obj.NewIgnitions(end+1, 1) = newIg;
            obj.PrevState = S;
        end

        function f = fractionAffected(obj)
            % Percentage of the original forest that is burning or burnt.
            f = 100 * (obj.Burning + obj.Burnt) / max(obj.TotalTrees, 1);
        end

        function T = toTable(obj)
            T = table(obj.Step, obj.Healthy, obj.Burning, obj.Burnt, ...
                      obj.Empty, obj.NewIgnitions, obj.fractionAffected(), ...
                      'VariableNames', {'Step', 'Healthy', 'Burning', 'Burnt', ...
                                        'Empty', 'NewIgnitions', 'PercentAffected'});
        end

        function s = summary(obj)
            [peak, idx] = max(obj.Burning);
            s.Duration            = obj.Step(end);
            s.PeakBurning         = peak;
            s.StepOfPeakBurning   = obj.Step(idx);
            s.FinalBurnt          = obj.Burnt(end);
            s.FinalHealthy        = obj.Healthy(end);
            s.PercentAffected     = obj.fractionAffected();
            s.PercentAffected     = s.PercentAffected(end);
            s.TotalIgnitions      = sum(obj.NewIgnitions);
        end

        function saveCSV(obj, filename)
            writetable(obj.toTable(), filename);
        end
    end
end
