
function [A,CH,RH]=hmreduce(A,CH,RH,LC,LR, SLC,SLR)
%HMREDUCE Reduce parts of cost matrix in the Hungerian method.
%
%[A,CH,RH]=hmreduce(A,CH,RH,LC,LR,SLC,SLR)
%Input:
%A   - Cost matrix.
%CH  - vector of column of 'next zeros' in each row.
%RH  - vector with list of unexplored rows.
%LC  - column labels.
%RC  - row labels.
%SLC - set of column labels.
%SLR - set of row labels.
%
%Output:
%A   - Reduced cost matrix.
%CH  - Updated vector of 'next zeros' in each row.
%RH  - Updated vector of unexplored rows.

% v1.0  96-06-14. Niclas Borlin, niclas@cs.umu.se.

n=size(A,1);

% Find which rows are covered, i.e. unlabelled.
coveredRows=LR==0;

% Find which columns are covered, i.e. labelled.
coveredCols=LC~=0;

r=find(~coveredRows);
c=find(~coveredCols);

% Get minimum of uncovered elements.
m=min(min(A(r,c)));

% Subtract minimum from all uncovered elements.
A(r,c)=A(r,c)-m;

% Check all uncovered columns..
for j=c
    % ...and uncovered rows in path order..
    for i=SLR
        % If this is a (new) zero..
        if (A(i,j)==0)
            % If the row is not in unexplored list..
            if (RH(i)==0)
                % ...insert it first in unexplored list.
                RH(i)=RH(n+1);
                RH(n+1)=i;
                % Mark this zero as "next free" in this row.
                CH(i)=j;
            end
            % Find last unassigned zero on row I.
            row=A(i,:);
            colsInList=-row(row<0);
            if (isempty(colsInList))
                % No zeros in the list.
                l=n+1;
            else
                l=colsInList(row(colsInList)==0);
            end
            % Append this zero to end of list.
            A(i,l)=-j;
        end
    end
end

% Add minimum to all doubly covered elements.
r=find(coveredRows);
c=find(coveredCols);

% Take care of the zeros we will remove.
[i,j]=find(A(r,c)<=0);

i=r(i);
j=c(j);

for k=1:length(i)
    % Find zero before this in this row.
    lj= A(i(k),:)==-j(k);
    % Link past it.
    A(i(k),lj)=A(i(k),j(k));
    % Mark it as assigned.
    A(i(k),j(k))=0;
end

A(r,c)=A(r,c)+m;

