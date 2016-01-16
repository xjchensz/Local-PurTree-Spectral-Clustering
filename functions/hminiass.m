
function [A,C,U]=hminiass(A)
%HMINIASS Initial assignment of the Hungarian method.
%
%[B,C,U]=hminiass(A)
%A - the reduced cost matrix.
%B - the reduced cost matrix, with assigned zeros removed from lists.
%C - a vector. C(J)=I means row I is assigned to column J,
%              i.e. there is an assigned zero in position I,J.
%U - a vector with a linked list of unassigned rows.

% v1.0  96-06-14. Niclas Borlin, niclas@cs.umu.se.

[n,np1]=size(A);

% Initalize return vectors.
C=zeros(1,n);
U=zeros(1,n+1);

% Initialize last/next zero "pointers".
LZ=zeros(1,n);
NZ=zeros(1,n);

for i=1:n
    % Set j to first unassigned zero in row i.
	lj=n+1;
	j=-A(i,lj);

    % Repeat until we have no more zeros (j==0) or we find a zero
	% in an unassigned column (c(j)==0).
    
	while (C(j)~=0)
		% Advance lj and j in zero list.
		lj=j;
		j=-A(i,lj);
	
		% Stop if we hit end of list.
		if (j==0)
			break;
		end
	end

	if (j~=0)
		% We found a zero in an unassigned column.
		
		% Assign row i to column j.
		C(j)=i;
		
		% Remove A(i,j) from unassigned zero list.
		A(i,lj)=A(i,j);

		% Update next/last unassigned zero pointers.
		NZ(i)=-A(i,j);
		LZ(i)=lj;

		% Indicate A(i,j) is an assigned zero.
		A(i,j)=0;
	else
		% We found no zero in an unassigned column.

		% Check all zeros in this row.

		lj=n+1;
		j=-A(i,lj);
		
		% Check all zeros in this row for a suitable zero in another row.
		while (j~=0)
			% Check the in the row assigned to this column.
			r=C(j);
			
			% Pick up last/next pointers.
			lm=LZ(r);
			m=NZ(r);
			
			% Check all unchecked zeros in free list of this row.
			while (m~=0)
				% Stop if we find an unassigned column.
				if (C(m)==0)
					break;
				end
				
				% Advance one step in list.
				lm=m;
				m=-A(r,lm);
			end
			
			if (m==0)
				% We failed on row r. Continue with next zero on row i.
				lj=j;
				j=-A(i,lj);
			else
				% We found a zero in an unassigned column.
			
				% Replace zero at (r,m) in unassigned list with zero at (r,j)
				A(r,lm)=-j;
				A(r,j)=A(r,m);
			
				% Update last/next pointers in row r.
				NZ(r)=-A(r,m);
				LZ(r)=j;
			
				% Mark A(r,m) as an assigned zero in the matrix . . .
				A(r,m)=0;
			
				% ...and in the assignment vector.
				C(m)=r;
			
				% Remove A(i,j) from unassigned list.
				A(i,lj)=A(i,j);
			
				% Update last/next pointers in row r.
				NZ(i)=-A(i,j);
				LZ(i)=lj;
			
				% Mark A(r,m) as an assigned zero in the matrix . . .
				A(i,j)=0;
			
				% ...and in the assignment vector.
				C(j)=i;
				
				% Stop search.
				break;
			end
		end
	end
end

% Create vector with list of unassigned rows.

% Mark all rows have assignment.
r=zeros(1,n);
rows=C(C~=0);
r(rows)=rows;
empty=find(r==0);

% Create vector with linked list of unassigned rows.
U=zeros(1,n+1);
U([n+1 empty])=[empty 0];
