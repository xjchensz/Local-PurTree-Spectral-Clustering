function [ Qv ] = computeQ( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);
Qv=0;

simX=1-distX;
simX=simX+diag(-diag(simX));

s=sum(simX,2);
m=sum(s);
for i=1:length(cluster)
    idx=find(y==cluster(i));
    a=simX(idx,idx)- (s(idx)*s(idx)')/m;
    Qv=Qv+sum(sum(a))-sum(sum(diag(diag(a))));
end
Qv=Qv/m;


