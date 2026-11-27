%% TEST 1: EMPTY FOREST

clear;
clc;

N = 50;
density = 0;
meanFlam = 0.5;
burnDuration = 3;

[forest, stateGrid] = initForest(N, density, meanFlam, burnDuration);

totalTrees = nnz(stateGrid);

fprintf('EMPTY FOREST VALIDATION\n');
fprintf('-----------------------\n');
fprintf('Total trees: %d\n', totalTrees);

if totalTrees == 0
    fprintf('TEST PASSED: Forest contains no trees.\n');
else
    fprintf('TEST FAILED: Unexpected trees found.\n');
end

%% TEST 2: ZERO IGNITION PROBABILITY

clear;
clc;

N = 50;
density = 0.8;
meanFlam = 0.5;
burnDuration = 3;

interactionRadius = 1.5;
baseIgnitionProb = 0;
windVector = [1 0];

[forest, stateGrid] = initForest(N, density, meanFlam, burnDuration);

[forest, stateGrid] = igniteFire(forest, stateGrid, 'center', 1);

initialBurning = nnz(stateGrid == TreeAgent.BURNING);

for t = 1:5
    forest = updateFireDynamics( ...
        forest, N, interactionRadius, baseIgnitionProb, windVector);

    stateGrid = getStateGrid(forest);
end

finalBurning = nnz(stateGrid == TreeAgent.BURNING);
finalBurnt = nnz(stateGrid == TreeAgent.BURNT);

fprintf('ZERO IGNITION VALIDATION\n');
fprintf('Initial burning trees: %d\n', initialBurning);
fprintf('Final burning trees: %d\n', finalBurning);
fprintf('Final burnt trees: %d\n', finalBurnt);

if finalBurning == 0 && finalBurnt > 0
    fprintf('TEST PASSED: Fire did not spread.\n');
else
    fprintf('TEST FAILED: Unexpected fire spread.\n');
end