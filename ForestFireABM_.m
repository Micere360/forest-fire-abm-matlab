%% FOREST FIRE SPREAD SIMULATION
% Capstone Project 2
% Member 4: Mirriam - Validation and Report Lead

clear;
clc;
close all;

%% 1. Simulation parameters

N = 50;
density = 0.8;
meanFlam = 0.5;
burnDuration = 3;

interactionRadius = 1.5;
baseIgnitionProb = 0.6;
windVector = [1 0];

maxSteps = 300;
pauseTime = 0.05;

%% 2. Initialize the forest

[forest, stateGrid] = initForest(N, density, meanFlam, burnDuration);

fprintf('Forest initialized successfully.\n');
fprintf('Total trees: %d\n', nnz(stateGrid));

%% 3. Start the initial fire

[forest, stateGrid] = igniteFire(forest, stateGrid, 'center', 1);

fprintf('Initial fire started.\n');

%% 4. Initialize logger and visualizer

logger = FireLogger();

totalTrees = nnz(stateGrid);

viz = FireVisualizer(stateGrid, totalTrees);

%% 5. Record the initial forest state

logger.record(0, stateGrid);
viz.update(stateGrid, logger, 0);

%% 6. Run the simulation

t = 0;

while t < maxSteps && any(stateGrid(:) == TreeAgent.BURNING)

    forest = updateFireDynamics( ...
        forest, N, interactionRadius, baseIgnitionProb, windVector);

    t = t + 1;

    stateGrid = getStateGrid(forest);

    logger.record(t, stateGrid);

    viz.update(stateGrid, logger, t);

    if pauseTime > 0
        pause(pauseTime);
    end

end

%% 7. Finish visualization

viz.finish();

%% 8. Display simulation results

results = logger.summary();

fprintf('\n==== SIMULATION RESULTS =====\n');

fprintf('Simulation duration: %d steps\n', results.Duration);
fprintf('Peak burning trees: %d\n', results.PeakBurning);
fprintf('Step of peak burning: %d\n', results.StepOfPeakBurning);
fprintf('Final burnt trees: %d\n', results.FinalBurnt);
fprintf('Final healthy trees: %d\n', results.FinalHealthy);
fprintf('Forest affected: %.2f%%\n', results.PercentAffected);
fprintf('Total ignitions: %d\n', results.TotalIgnitions);

%% 9. Save simulation metrics

logger.saveCSV('fire_simulation_results.csv');

fprintf('\nSimulation results saved successfully.\n');