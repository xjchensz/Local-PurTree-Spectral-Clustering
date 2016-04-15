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

weighta=zeros(size(distX,1),size(distX,1));
weightb=zeros(size(distX,1),size(distX,1));
ww=zeros(size(distX,1),1);
for i=1:size(distX,1)
    if sz(y(i))>1
         weighta(i,find(y==cluster(i)))=1/(sz(y(i))-1);
    end
   
    for j=1:length(cluster)
        if j~=y(i)
            weightb(i,find(y==cluster(j)))= w(j);
        end
    end
    
    ww(i)=w(y(i));
end

ax=sum(distX.*weighta,2);
temp=distX.*weightb;
for i=1:size(distX,1)
    temp(y(i))=NaN;
end

bx=min(temp,[],2);


diffx=(bx-ax)./max(ax,bx);

si=sum(diffx.*ww)/sum(sz);

