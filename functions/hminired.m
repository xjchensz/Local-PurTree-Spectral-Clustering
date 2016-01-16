function A=hminired(A)
%HMINIRED Initial reduction of cost matrix for the Hungarian method.
%
%B=assredin(A)
%A - the unreduced cost matris.
%B - the reduced cost matrix with linked zeros in each row.

% v1.0  96-06-13. Niclas Borlin, niclas@cs.umu.se.

[m,n]=size(A);

% Subtract column-minimum values from each column.
colMin=min(A);
A=A-colMin(ones(n,1),:);

% Subtract row-minimum values from each row.
rowMin=min(A')';
A=A-rowMin(:,ones(1,n));

% Get positions of all zeros.
[i,j]=find(A==0);

% Extend A to give room for row zero list header column.
A(1,n+1)=0;
for k=1:n
    % Get all column in this row. 
    cols=j(k==i)';
    % Insert pointers in matrix.
    A(k,[n+1 cols])=[-cols 0];
end