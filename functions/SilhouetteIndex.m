function [ si ] = SilhouetteIndex( distX, y )
%LOGWK Summary of this function goes here
%   Detailed explanation goes here
cluster=unique(y);


w=zeros(length(cluster),1);
sz=zeros(length(cluster),1);
for i=1:length(cluster)
    idx=find(y==cluster(i));
    sz(i)=length(idx);
end
w=1./sz;

weighta=zeros(size(distX,1),length(cluster));
weightb=zeros(size(distX,1),length(cluster));
ww=zeros(size(distX,1),1);
for i=1:size(distX,1)
    if sz(y(i))>0
         weighta(i,y(i))=1/(sz(y(i))-1);
    end
   
    for j=1:length(cluster)
        if j~=y(i)
            weightb(i,j)= w(j);
        end
    end
    
    ww(i)=w(y(i));
end

ax=sum(distX*weighta,2);
bx=min(distX*weightb,[],2);
diffx=(bx-ax)./max(ax,bx);

si=sum(diffx.*ww)/sum(sz);

