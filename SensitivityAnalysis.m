%% SENSITIVITY ANALYSIS
% Testing the effect of ignition probability

clear;
clc;

% Fixed simulation parameters
N = 50;
density = 0.8;
meanFlam = 0.5;
burnDuration = 3;

interactionRadius = 1.5;
windVector = [1 0];

maxSteps = 300;

% Ignition probabilities to compare
ignitionProbabilities = [0.2, 0.5, 0.8];

% Number of repetitions per probability
numRuns = 10;

% Storage for experiment results

meanAffected = zeros(length(ignitionProbabilities), 1);
meanDuration = zeros(length(ignitionProbabilities), 1);
meanBurnt = zeros(length(ignitionProbabilities), 1);

%% Run sensitivity experiments

for pIndex = 1:length(ignitionProbabilities)

    currentProbability = ignitionProbabilities(pIndex);

    affectedResults = zeros(numRuns, 1);
    durationResults = zeros(numRuns, 1);
    burntResults = zeros(numRuns, 1);

    for run = 1:numRuns

        % Create a fresh forest
        [forest, stateGrid] = initForest(N, density, meanFlam, burnDuration);

        % Start fire at the centre
        [forest, stateGrid] = igniteFire(forest, stateGrid, 'center', 1);

        totalTrees = nnz(stateGrid);
        t = 0;

        % Simulate fire spread
        while t < maxSteps && any(stateGrid(:) == TreeAgent.BURNING)

            forest = updateFireDynamics( ...
                forest, N, interactionRadius, currentProbability, windVector);

            t = t + 1;
            stateGrid = getStateGrid(forest);

        end

        % Record results
        affectedResults(run) = 100 * ...
            nnz(stateGrid == TreeAgent.BURNING | stateGrid == TreeAgent.BURNT) ...
            / max(totalTrees, 1);

        durationResults(run) = t;

        burntResults(run) = nnz(stateGrid == TreeAgent.BURNT);

    end

    % Calculate averages
    meanAffected(pIndex) = mean(affectedResults);
    meanDuration(pIndex) = mean(durationResults);
    meanBurnt(pIndex) = mean(burntResults);

    fprintf('Completed probability: %.1f\n', currentProbability);

end









%% Display sensitivity analysis results

SensitivityResults = table( ...
    ignitionProbabilities', ...
    meanAffected, ...
    meanDuration, ...
    meanBurnt, ...
    'VariableNames', { ...
    'IgnitionProbability', ...
    'MeanPercentAffected', ...
    'MeanDuration', ...
    'MeanBurntTrees'});

disp(SensitivityResults);




%% Save sensitivity analysis results

writetable(SensitivityResults, 'sensitivity_analysis_results.csv');

fprintf('\nSensitivity analysis results saved successfully.\n');

