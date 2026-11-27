%% TEST 4: WIND DIRECTION INFLUENCE

clear;
clc;

dist = 1;

% Wind blowing east
windVector = [1 0];

% Neighbour downwind
downwind = calculateWindFactor(1, 0, dist, windVector);

% Neighbour upwind
upwind = calculateWindFactor(-1, 0, dist, windVector);

% Neighbour perpendicular to wind
sideways = calculateWindFactor(0, 1, dist, windVector);

fprintf('WIND INFLUENCE VALIDATION\n');
fprintf('Downwind factor: %.2f\n', downwind);
fprintf('Upwind factor: %.2f\n', upwind);
fprintf('Sideways factor: %.2f\n', sideways);

if downwind > sideways && sideways > upwind
    fprintf('TEST PASSED: Wind direction influences fire spread.\n');
else
    fprintf('TEST FAILED: Wind influence is incorrect.\n');
end
