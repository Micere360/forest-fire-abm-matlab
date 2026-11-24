function S = agentsToStateMatrix(treeAgents)
% AGENTSTOSTATEMATRIX Convert a 2D array of TreeAgent objects to a numeric
% matrix that imagesc can draw and the logger can count.
%
%   S = agentsToStateMatrix(treeAgents)
%
%   Encoding:  0 = empty / other,  1 = Healthy,  2 = Burning,  3 = Burnt
%
%   Reads only the .Status property (string or char), so it works with any
%   TreeAgent implementation that uses "Healthy", "Burning" and "Burnt".

    [nRows, nCols] = size(treeAgents);
    S = zeros(nRows, nCols);

    for r = 1:nRows
        for c = 1:nCols
            switch string(treeAgents(r, c).Status)
                case "Healthy"
                    S(r, c) = 1;
                case "Burning"
                    S(r, c) = 2;
                case "Burnt"
                    S(r, c) = 3;
                otherwise
                    S(r, c) = 0;
            end
        end
    end
end
