%% TEST 5: TREE POPULATION CONSERVATION

clear;
clc;

N = 50;
density = 0.8;
meanFlam = 0.5;
burnDuration = 3;

interactionRadius = 1.5;
baseIgnitionProb = 0.6;
windVector = [1 0];

maxSteps = 300;

[forest, stateGrid] = initForest(N, density, meanFlam, burnDuration);

initialTrees = nnz(stateGrid);

[forest, stateGrid] = igniteFire(forest, stateGrid, 'center', 1);

t = 0;

while t < maxSteps && any(stateGrid(:) == TreeAgent.BURNING)

    forest = updateFireDynamics( ...
        forest, N, interactionRadius, baseIgnitionProb, windVector);

    t = t + 1;
    stateGrid = getStateGrid(forest);

end

healthy = nnz(stateGrid == TreeAgent.HEALTHY);
burning = nnz(stateGrid == TreeAgent.BURNING);
burnt = nnz(stateGrid == TreeAgent.BURNT);

finalTrees = healthy + burning + burnt;

fprintf('TREE CONSERVATION VALIDATION\n');
fprintf('Initial trees: %d\n', initialTrees);
fprintf('Healthy trees: %d\n', healthy);
fprintf('Burning trees: %d\n', burning);
fprintf('Burnt trees: %d\n', burnt);
fprintf('Final trees: %d\n', finalTrees);

if initialTrees == finalTrees
    fprintf('TEST PASSED: Tree population was conserved.\n');
else
    fprintf('TEST FAILED: Tree population changed.\n');
end