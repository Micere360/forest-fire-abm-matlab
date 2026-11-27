%  Tests for TreeAgent, initForest and igniteFire.
% Author : Addah Mwaniki (Student ID: 675630)
clear; clc; close all;

N = 50;  density = 0.8;  meanFlam = 0.5;  burnDuration = 3;

%% Test 1: forest creation
[forest, grid] = initForest(N, density, meanFlam, burnDuration);
nTrees = nnz(grid);
fprintf('Test 1: trees = %d (expected about %d)\n', nTrees, round(density*N^2));

%% Test 2: ignition at the centre
[forest, grid] = igniteFire(forest, grid, 'center', 1);
fprintf('Test 2: burning trees = %d (expected 1)\n', nnz(grid == TreeAgent.BURNING));

%% Test 3: a burning tree becomes burnt after BurnDuration updates
[r, c] = find(grid == TreeAgent.BURNING, 1);
t = forest{r, c};
for step = 1:burnDuration
    t.update();
end
fprintf('Test 3: status after %d updates = %d (expected 3)\n', burnDuration, t.Status);

%% Test 4: helper rebuilds the grid correctly
grid2 = getStateGrid(forest);
fprintf('Test 4: burnt trees in rebuilt grid = %d (expected 1)\n', nnz(grid2 == TreeAgent.BURNT));

%% Picture of the initial forest
imagesc(grid2); colorbar; axis equal tight
title('Forest state: 0 empty, 1 healthy, 2 burning, 3 burnt');