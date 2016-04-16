function [ di ] = DunnIndex(  distX, y  )
%DUNNINDEX Summary of this function goes here
%   Detailed explanation goes here


cluster=unique(y);

clusterDis=zeros(length(cluster),length(cluster));

mindis=zeros(length(cluster),length(cluster));
maxdis=zeros(length(cluster),1);
for i=1:length(cluster)
    maxdis(i)=max(max(distX(find(y==cluster(i)),find(y==cluster(i)))));
    for j=1:length(cluster)
        sub = distX(find(y==cluster(i)),find(y==cluster(j)));
        mindis(i,j)=min(min(sub));   
    end
end

mindis=mindis+diag(diag(zeros(length(cluster),length(cluster))*NaN));

di=min(min(mindis,[],'omitnan'))/max(maxdis(maxdis>0));
end

