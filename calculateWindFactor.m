function windFactor = calculateWindFactor(dx, dy, dist, windVector)
% CALCULATEWINDFACTOR Computes directional wind multiplier for fire spread.
%   Inputs:
%       dx, dy     - Coordinate differences (neighbor - burningTree)
%       dist       - Euclidean distance between the two trees
%       windVector - 1x2 vector [WindX, WindY]
%   Output:
%       windFactor - Scalar multiplier (minimum 0.1 for upwind suppression)

if dist <= 0
    windFactor = 0;
    return;
end

% Unit direction vector from burning tree to healthy neighbor
directionVector = [dx, dy] / dist;

% Dot product measures alignment with wind direction
windAlignment = dot(directionVector, windVector);

% Downwind (> 1.0) accelerates spread; upwind (< 1.0) suppresses it
windFactor = max(0.1, 1.0 + windAlignment);
end