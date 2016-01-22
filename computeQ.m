function [ Q ] = computeQ( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);
Q=0;

m=sum(sum(distX));
d=sum(distX,2);
for i=1:length(cluster)
    idx=find(y==cluster(i));
    Q=Q+sum(sum(distX(idx,idx)- (d(idx)*d(idx)')/(2*m)));
end
Q=Q/(2*m);


