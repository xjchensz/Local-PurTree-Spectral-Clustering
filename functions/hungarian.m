%%
function [C,T]=hungarian(A)
%HUNGARIAN Solve the Assignment problem using the Hungarian method.
%
%[C,T]=hungarian(A)
%A - a square cost matrix.
%C - the optimal assignment.
%T - the cost of the optimal assignment.
%s.t. T = trace(A(C,:)) is minimized over all possible assignments.

% Adapted from the FORTRAN IV code in Carpaneto and Toth, "Algorithm 548:
% Solution of the assignment problem [H]", ACM Transactions on
% Mathematical Software, 6(1):104-111, 1980.

% v1.0  96-06-14. Niclas Borlin, niclas@cs.umu.se.
%                 Department of Computing Science, Ume?University,
%                 Sweden. 
%                 All standard disclaimers apply.

% A substantial effort was put into this code. If you use it for a
% publication or otherwise, please include an acknowledgement or at least
% notify me by email. /Niclas

[m,n]=size(A);

if (m~=n)
    error('HUNGARIAN: Cost matrix must be square!');
end

% Save original cost matrix.
orig=A;

% Reduce matrix.
A=hminired(A);

% Do an initial assignment.
[A,C,U]=hminiass(A);

% Repeat while we have unassigned rows.
while (U(n+1))
    % Start with no path, no unchecked zeros, and no unexplored rows.
    LR=zeros(1,n);
    LC=zeros(1,n);
    CH=zeros(1,n);
    RH=[zeros(1,n) -1];
    
    % No labelled columns.
    SLC=[];
    
    % Start path in first unassigned row.
    r=U(n+1);
    % Mark row with end-of-path label.
    LR(r)=-1;
    % Insert row first in labelled row set.
    SLR=r;
    
    % Repeat until we manage to find an assignable zero.
    while (1)
        % If there are free zeros in row r
        if (A(r,n+1)~=0)
            % ...get column of first free zero.
            l=-A(r,n+1);
            
            % If there are more free zeros in row r and row r in not
            % yet marked as unexplored..
            if (A(r,l)~=0 & RH(r)==0)
                % Insert row r first in unexplored list.
                RH(r)=RH(n+1);
                RH(n+1)=r;
                
                % Mark in which column the next unexplored zero in this row
                % is.
                CH(r)=-A(r,l);
            end
        else
            % If all rows are explored..
            if (RH(n+1)<=0)
                % Reduce matrix.
                [A,CH,RH]=hmreduce(A,CH,RH,LC,LR,SLC,SLR);
            end
            
            % Re-start with first unexplored row.
            r=RH(n+1);
            % Get column of next free zero in row r.
            l=CH(r);
            % Advance "column of next free zero".
            CH(r)=-A(r,l);
            % If this zero is last in the list..
            if (A(r,l)==0)
                % ...remove row r from unexplored list.
                RH(n+1)=RH(r);
                RH(r)=0;
            end
        end
        
        % While the column l is labelled, i.e. in path.
        while (LC(l)~=0)
            % If row r is explored..
            if (RH(r)==0)
                % If all rows are explored..
                if (RH(n+1)<=0)
                    % Reduce cost matrix.
                    [A,CH,RH]=hmreduce(A,CH,RH,LC,LR,SLC,SLR);
                end
                
                % Re-start with first unexplored row.
                r=RH(n+1);
            end
            
            % Get column of next free zero in row r.
            l=CH(r);
            
            % Advance "column of next free zero".
            CH(r)=-A(r,l);
            
            % If this zero is last in list..
            if(A(r,l)==0)
                % ...remove row r from unexplored list.
                RH(n+1)=RH(r);
                RH(r)=0;
            end
        end
        
        % If the column found is unassigned..
        if (C(l)==0)
            % Flip all zeros along the path in LR,LC.
            [A,C,U]=hmflip(A,C,LC,LR,U,l,r);
            % ...and exit to continue with next unassigned row.
            break;
        else
            % ...else add zero to path.
            
            % Label column l with row r.
            LC(l)=r;
            
            % Add l to the set of labelled columns.
            SLC=[SLC l];
            
            % Continue with the row assigned to column l.
            r=C(l);
            
            % Label row r with column l.
            LR(r)=l;
            
            % Add r to the set of labelled rows.
            SLR=[SLR r];
        end
    end
end

% Calculate the total cost.
T=sum(orig(logical(sparse(C,1:size(orig,2),1))));

