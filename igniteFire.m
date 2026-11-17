function [forest, stateGrid] = igniteFire(forest, stateGrid, mode, k)
% igniteFire  Start the initial fire(s).
%
% Author : Addah Mwaniki (Student ID: 675630)
%
% Inputs:
%   forest, stateGrid   from initForest
%   mode   'center' = ignite the tree nearest the middle of the grid
%          'random' = ignite k randomly chosen trees
%   k      number of random ignitions (used only when mode = 'random')

N = size(forest, 1);
hasTree = ~cellfun(@isempty, forest);
[rows, cols] = find(hasTree);

if isempty(rows)
    error('igniteFire:noTrees', 'The forest has no trees to ignite.');
end

if strcmp(mode, 'center')
    d = (rows - N/2).^2 + (cols - N/2).^2;   % distance to the centre
    [~, idx] = min(d);
elseif strcmp(mode, 'random')
    idx = randperm(numel(rows), min(k, numel(rows)));
else
    error('igniteFire:badMode', 'mode must be ''center'' or ''random''.');
end

for i = idx(:)'
    forest{rows(i), cols(i)}.ignite();
    stateGrid(rows(i), cols(i)) = TreeAgent.BURNING;
end
end