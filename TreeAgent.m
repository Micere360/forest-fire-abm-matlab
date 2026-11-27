classdef TreeAgent < handle
    % TreeAgent  One tree in the forest fire agent-based model.
    %
    % Author : Addah Mwaniki (Student ID: 675630)
    % Project: Capstone Project 2 - Modeling Forest Fire Spread (ABM)
    %
    % Status codes: 1 = Healthy, 2 = Burning, 3 = Burnt
    %
    % Coordinates: X = column, Y = row (the same grid index used by imagesc).

    properties
        Row                      % row index in the grid
        Col                      % column index in the grid
        X                        % x coordinate (= Col)
        Y                        % y coordinate (= Row)
        Status       = 1         % current state (see codes above)
        Flammability = 0.5       % 0 to 1, base chance of catching fire
        BurnTime     = 0         % time steps spent burning so far
        BurnDuration = 3         % time steps a tree burns before it is burnt
    end

    properties (Constant)
        HEALTHY = 1;
        BURNING = 2;
        BURNT   = 3;
    end

    methods
        function obj = TreeAgent(row, col, flammability, burnDuration)
            % Constructor: creates a healthy tree at (row, col)
            if nargin > 0
                obj.Row = row;
                obj.Col = col;
                obj.X   = col;
                obj.Y   = row;
                obj.Flammability = flammability;
                obj.BurnDuration = burnDuration;
            end
        end

        function ignite(obj)
            % Set a healthy tree on fire
            if obj.Status == TreeAgent.HEALTHY
                obj.Status   = TreeAgent.BURNING;
                obj.BurnTime = 0;
            end
        end

        function update(obj)
            % Advance the burn timer by one time step.
            % Call once per tree per time step.
            if obj.Status == TreeAgent.BURNING
                obj.BurnTime = obj.BurnTime + 1;
                if obj.BurnTime >= obj.BurnDuration
                    obj.Status = TreeAgent.BURNT;
                end
            end
        end

        function tf = isHealthy(obj)
            tf = (obj.Status == TreeAgent.HEALTHY);
        end

        function tf = isBurning(obj)
            tf = (obj.Status == TreeAgent.BURNING);
        end

        function tf = isBurnt(obj)
            tf = (obj.Status == TreeAgent.BURNT);
        end
    end
end