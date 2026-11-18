function treeAgents = updateFireDynamics(treeAgents, gridSize, interactionRadius, baseIgnitionProb, windVector)
% UPDATEFIREDYNAMICS Executes one time step of fire spread and state updates.
%   Inputs:
%       treeAgents        - 2D array of TreeAgent objects
%       gridSize          - Dimension of the square forest grid
%       interactionRadius - Max distance for fire transmission
%       baseIgnitionProb  - Base probability of ignition [0, 1]
%       windVector        - 1x2 vector [WindX, WindY]
%   Output:
%       treeAgents        - Updated 2D array of TreeAgent objects

treesToIgnite = [];
searchRange = ceil(interactionRadius);

% --- Step 1: Neighborhood Interaction & Stochastic Ignition ---
for x = 1:gridSize
    for y = 1:gridSize
        currentAgent = treeAgents(x, y);

        if currentAgent.Status == "Burning"
            % Define bounded local neighborhood
            minX = max(1, x - searchRange);
            maxX = min(gridSize, x + searchRange);
            minY = max(1, y - searchRange);
            maxY = min(gridSize, y + searchRange);

            for nx = minX:maxX
                for ny = minY:maxY
                    neighbor = treeAgents(nx, ny);

                    if neighbor.Status == "Healthy"
                        dx = neighbor.XPosition - currentAgent.XPosition;
                        dy = neighbor.YPosition - currentAgent.YPosition;
                        dist = sqrt(dx^2 + dy^2);

                        if dist > 0 && dist <= interactionRadius
                            % Compute wind multiplier using calculateWindFactor
                            windFactor = calculateWindFactor(dx, dy, dist, windVector);

                            % Net ignition probability
                            pIgnite = (baseIgnitionProb * neighbor.Flammability * windFactor) / dist;
                            pIgnite = min(pIgnite, 1.0);

                            % Stochastic ignition check
                            if rand() < pIgnite
                                treesToIgnite = [treesToIgnite; neighbor]; %#ok<AGROW>
                            end
                        end
                    end
                end
            end
        end
    end
end

% --- Step 2: Apply State Transitions ---
% Ignite newly caught healthy trees (Healthy -> Burning)
for i = 1:length(treesToIgnite)
    treesToIgnite(i).ignite();
end

% Advance burn timers for existing burning trees (Burning -> Burnt)
for x = 1:gridSize
    for y = 1:gridSize
        treeAgents(x, y).updateStatus();
    end
end
end