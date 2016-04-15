function [ si ] = SilhouetteIndex( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);


w=zeros(length(cluster),1);
size=zeros(length(cluster),1);
for i=1:length(cluster)
    idx=find(y==cluster(i));
    size(i)=1/length(idx);
end
w=1./size;

weighta=zeros(size(distX,1),length(cluster));
weightb=zeros(size(distX,1),length(cluster));
for i=1:size(weight,1)
    weighta(i,y(i))=w(y(i));
    for j=1:length(cluster)
            weightb(i,j)= w(j);
    end
end

ax=sum(distX*weighta,1);
bx=sum(distX*weightb,1);
diffx=(bx-ax)./max(ax,bx);

si=sum(diffx./size)/sum(size);

