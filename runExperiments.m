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

numK=[6 5 5 4];

index=-1;
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


ncm=zeros(length(k),length(c));
wm=zeros(length(k),length(c),level);

Q=zeros(length(k),length(c));
nlw=zeros(length(k),length(c));
SI=zeros(length(di),length(c),length(k));
DI=zeros(length(di),length(c),length(k));
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
        nlw(j,i)=NLW(distX,y);
        Q(j,i)=computeQ(distX,y);
        SI(j,i)=SilhouetteIndex(distX,y);
        DI(j,i)=DunnIndex(distX,y);
        sprintf('Q: %d', Q(j,i))
    end
end


if index>0
    path=[pwd, path, '\parts'];
    if ~exist(path,'dir')
        mkdir path;
    end
    save([path '\nlw',num2str(index),'.mat'],'nlw');
    save([path '\ncm',num2str(index),'.mat'],'ncm');
    save([path '\wm',num2str(index),'.mat'],'wm');
    save([path '\Q',num2str(index),'.mat'],'Q');
    save([path '\SI',num2str(index),'.mat'],'SI');
    save([path '\DI',num2str(index),'.mat'],'DI');
else
    path=['.', path];
    save([path '\nlw.mat'],'nlw');
    save([path '\ncm.mat'],'ncm');
    save([path '\wm.mat'],'wm');
    save([path '\Q.mat'],'Q');
    save([path '\SI.mat'],'SI');
    save([path '\DI.mat'],'DI');
end


%%