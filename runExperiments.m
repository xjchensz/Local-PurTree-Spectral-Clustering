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


load(['.',path,name,'.mat'],'D');

level=size(D,3);
sprintf('The number of objects is: %d', size(D,1))

% nearest neighbors
k=5:10:20;

% number of clusters
c=20:21;

% eta
eta=0.1:0.1:2;
numEta=[2,4,6];

index=2;
if index>=0
    start=0;
    for i=1:index-1
        start=start+numEta(i);
    end
    eta=eta(start+1:start+numEta(index));
end


lw=zeros(length(eta),length(k),length(c));
ncm=zeros(length(eta),length(k),length(c));
wm=zeros(length(eta),length(k),length(c),level);

for i=1:length(c)
    for j=1:length(k)
        for l=1:length(eta)
            [y, ~, W, distX, ~]=LPT(D,c(i),k(j),eta(l));
            nc=length(unique(y));
            ncm(l,j,i)=nc;
            wm(l,j,i,:)=W;
            lw(l,j,i)=logWK(distX,y);
        end
    end
end



if index>=0
    path=['.', path, '\parts'];
    if ~exist(path,'dir')
        mkdir path;
    end
    save([path '\lw',num2str(index),'.mat'],'lw');
    save([path '\ncm',num2str(index),'.mat'],'ncm');
    save([path '\wm',num2str(index),'.mat'],'wm');
else
    path=['.', path];
    save([path '\lw.mat'],'lw');
    save([path '\ncm.mat'],'ncm');
    save([path '\wm.mat'],'wm');
end

%%