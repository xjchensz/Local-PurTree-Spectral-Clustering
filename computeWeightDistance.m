% WeightDistance
% 
%%
function [ Dist ] = computeWeightDistance( W,Z,idx)

level=size(Z,3); %levels
num = size(Z,1);%no. of objects
if nargin<3
    Dist=zeros(num,size(Z,2));
    for h = 1:level
        F=W(h,1)*Z(:,:,h);
        Dist=F+Dist;
    end
else
    Dist=zeros(num,size(idx,2));
    for h = 1:level
        F=W(h,1)*Z(:,:,h);
        Dist=F(i,idx)+Dist;
    end
end

end
%%
