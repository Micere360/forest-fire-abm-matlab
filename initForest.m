function [forest, stateGrid] = initForest(N, density, meanFlam, burnDuration)
% initForest  Create an N-by-N forest of TreeAgent objects.
%
% Author : Addah Mwaniki (Student ID: 675630)
%
% Inputs:
%   N            grid size (N x N cells)
%   density      probability (0 to 1) that a cell contains a tree
%   meanFlam     average flammability of the trees (0 to 1)
%   burnDuration time steps a tree burns before becoming burnt
%
% Outputs:
%   forest       N x N cell array; each cell is a TreeAgent or [] (empty)
%   stateGrid    N x N matrix: 0 empty, 1 healthy, 2 burning, 3 burnt

forest    = cell(N, N);
stateGrid = zeros(N, N);

for r = 1:N
    for c = 1:N
        if rand < density
            % flammability varies a little around the mean, kept within 0 to 1
            flam = min(max(meanFlam + 0.1*randn, 0), 1);
            forest{r, c}    = TreeAgent(r, c, flam, burnDuration);
            stateGrid(r, c) = TreeAgent.HEALTHY;
        end
    end
end
end