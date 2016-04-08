function [y] = NCut(A, c)
%%
clc; close all;

n = size(A,1); % Total number of points

% RCut & NCut
D = diag(sum(A));
nRepeat = 100;
Ini = zeros(n, nRepeat);
for jj = 1 : nRepeat
    Ini(:, jj) = randsrc(n, 1, 1:c);
end;


% NCut
fprintf('Normalized Cut\n');
Dd = diag(D);
Dn = spdiags(sqrt(1./Dd),0,n,n);
An = Dn*A*Dn;
An = (An+An')/2;
[Fng, D] = eig1(full(An), c, 1, 1);
Fng = Fng./repmat(sqrt(sum(Fng.^2,2)),1,c);  %optional
y = tuneKmeans(Fng, Ini);


%%