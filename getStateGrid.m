function stateGrid = getStateGrid(forest)
% getStateGrid  Build the 0/1/2/3 state matrix from the forest.
%
% Author : Addah Mwaniki (Student ID: 675630)

N = size(forest, 1);
M = size(forest, 2);
stateGrid = zeros(N, M);
for r = 1:N
    for c = 1:M
        if ~isempty(forest{r, c})
            stateGrid(r, c) = forest{r, c}.Status;
        end
    end
end
end