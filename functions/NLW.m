function [ lw ] = NLW( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);
lw=0;
for i=1:length(cluster)
    idx=find(y==cluster(i));
    lw=lw+sum(sum(distX(idx,idx)))/length(idx);
end
lw=log(lw/2)-log(sum(sum(distX)));
end

