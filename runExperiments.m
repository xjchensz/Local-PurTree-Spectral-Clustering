%test computeLogWk
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
path='\dis_1338';
name='\dis_1338';
addpath([folder_now, path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);


load([folder_now,path,name,'.mat'],'D');

level=size(D,3);
sprintf('The number of objects is: %d', size(D,1))

% nearest neighbors
k=5:5:100;

numK=[7 5 4 4];

index=1;
sprintf('Index: %d',index)

if index>0
    start=0;
    for i=1:index-1
        start=start+numK(i);
    end
    k=k(start+1:start+numK(index));
end

% number of clusters
c=5:100;

num=size(D,1);

lw=zeros(length(k),length(c));
ncm=zeros(length(k),length(c));
wm=zeros(length(k),length(c),level);
Q=zeros(length(k),length(c));

for i=1:length(c)
    for j=1:length(k)
        try
            [y, ~, W, distX, ~]=LPS(D,c(i),k(j),1);
        catch
            continue;
        end
        nc=length(unique(y));
        ncm(j,i)=nc;
        wm(j,i,:)=W;
        lw(j,i)=logWK(distX,y);
        Q(j,i)=computeQ(distX,y);
        sprintf('Q: %d', Q(j,i))
    end
end


if index>0
    path=[pwd, path, '\parts'];
    if ~exist(path,'dir')
        mkdir path;
    end
    save([path '\lw',num2str(index),'.mat'],'lw');
    save([path '\ncm',num2str(index),'.mat'],'ncm');
    save([path '\wm',num2str(index),'.mat'],'wm');
    save([path '\Q',num2str(index),'.mat'],'Q');
else
    path=['.', path];
    save([path '\lw.mat'],'lw');
    save([path '\ncm.mat'],'ncm');
    save([path '\wm.mat'],'wm');
    save([path '\Q.mat'],'Q');
end


%%