function [lwk, mdist, gwk] = WK( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
clusters=unique(y);
wk=0;
for i=1:length(clusters)
    idx=find(y==clusters(i));
    wk=wk+sum(sum(distX(idx,idx)))/length(idx);
end
lwk=log(wk/2);
mdist=mean(mean(distX));
gwk=wk/mdist;
end

