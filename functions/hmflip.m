function [A,C,U]=hmflip(A,C,LC,LR,U,l,r)
%HMFLIP Flip assignment state of all zeros along a path.
%
%[A,C,U]=hmflip(A,C,LC,LR,U,l,r)
%Input:
%A   - the cost matrix.
%C   - the assignment vector.
%LC  - the column label vector.
%LR  - the row label vector.
%U   - the 
%r,l - position of last zero in path.
%Output:
%A   - updated cost matrix.
%C   - updated assignment vector.
%U   - updated unassigned row list vector.

% v1.0  96-06-14. Niclas Borlin, niclas@cs.umu.se.

n=size(A,1);

while (1)
    % Move assignment in column l to row r.
    C(l)=r;
    
    % Find zero to be removed from zero list..
    
    % Find zero before this.
    m=find(A(r,:)==-l);
    
    % Link past this zero.
    A(r,m)=A(r,l);
    
    A(r,l)=0;
    
    % If this was the first zero of the path..
    if (LR(r)<0)
        ...remove row from unassigned row list and return.
        U(n+1)=U(r);
        U(r)=0;
        return;
    else
        
        % Move back in this row along the path and get column of next zero.
        l=LR(r);
        
        % Insert zero at (r,l) first in zero list.
        A(r,l)=A(r,n+1);
        A(r,n+1)=-l;
        
        % Continue back along the column to get row of next zero in path.
        r=LC(l);
    end
end
