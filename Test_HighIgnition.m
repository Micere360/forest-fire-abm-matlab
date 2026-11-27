%% TEST 3: HIGH IGNITION PROBABILITY

clear;
clc;

rng(1);

N = 50;
density = 0.8;
meanFlam = 0.5;
burnDuration = 3;

interactionRadius = 1.5;
baseIgnitionProb = 1.0;
windVector = [1 0];

[forest, stateGrid] = initForest(N, density, meanFlam, burnDuration);

[forest, stateGrid] = igniteFire(forest, stateGrid, 'center', 1);

initialBurning = nnz(stateGrid == TreeAgent.BURNING);

t = 0;

while t < 300 && any(stateGrid(:) == TreeAgent.BURNING)

    forest = updateFireDynamics( ...
        forest, N, interactionRadius, baseIgnitionProb, windVector);

    t = t + 1;
    stateGrid = getStateGrid(forest);

end

finalBurnt = nnz(stateGrid == TreeAgent.BURNT);

fprintf('HIGH IGNITION VALIDATION\n');
fprintf('Initial burning trees: %d\n', initialBurning);
fprintf('Final burnt trees: %d\n', finalBurnt);
fprintf('Simulation duration: %d steps\n', t);

if finalBurnt > initialBurning
    fprintf('TEST PASSED: Fire spread successfully.\n');
else
    fprintf('TEST FAILED: Fire did not spread as expected.\n');
end