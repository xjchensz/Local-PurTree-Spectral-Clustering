function [ si ] = SilhouetteIndex( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);


sz=zeros(length(cluster),1);
ww=zeros(length(cluster),1);
weight=zeros(size(distX,1),length(cluster));
for i=1:length(cluster)
    idx=find(y==cluster(i));
    sz(i)=length(idx);
    weight(idx,i)=1/sz(i);
    ww(idx)=1/sz(i);
end


temp=distX*weight;
ax=zeros(size(distX,1),1);
bx=zeros(size(distX,1),1);
for i=1:length(ax)
    if sz(y(i))>1
        ax(i)=temp(i,y(i))*sz(y(i))/(sz(y(i))-1);
    end
    temp(i,y(i))=NaN;
    bx(i)=min(temp(i,:),[],'omitnan');
end

diffx=(bx-ax)./max(ax,bx);

si=diffx'*ww/sum(sz);

