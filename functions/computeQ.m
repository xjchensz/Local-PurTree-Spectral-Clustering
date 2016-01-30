function [ Q ] = computeQ( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);
Q=0;

simX=1-distX;

s=sum(simX,2);
m=sum(s);
for i=1:length(cluster)
    idx=find(y==cluster(i));
    Q=Q+sum(sum(simX(idx,idx)- (s(idx)*s(idx)')/m));
end
Q=Q/m;


