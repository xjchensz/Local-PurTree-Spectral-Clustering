function [y] = RCut(A, c)
%%
clc; close all;

D = diag(sum(A));
nRepeat = 100;
n=size(A,1);
Ini = zeros(n, nRepeat);
for jj = 1 : nRepeat
    Ini(:, jj) = randsrc(n, 1, 1:c);
end;

% RCut
fprintf('Ratio Cut\n');
[Fg, tmpD] = eig1(full(D-A), c, 0, 1);
Fg = Fg./repmat(sqrt(sum(Fg.^2,2)),1,c);  %optional
y = tuneKmeans(Fg, Ini);

%%