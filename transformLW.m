%%
clc;
%clear all;

folder_now = pwd;
path='\dis_1338';
name='\dis_1338';
addpath([folder_now, path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\lw.mat'],'lw');
load(['.',path,'\ncm.mat'],'ncm');
load(['.',path,'\wm.mat'],'wm');
load([folder_now,path,name,'.mat'],'D');


% nearest neighbors
k=5:5:50;

% number of clusters
c=5:50;

% eta
eta=0.1:0.1:2;

level = size(wm,4);

W=zeros(size(wm,1),1);

for i=1:size(wm,1)
    
    W(i) = wm(i,1,1,1);
    
end

distX=computeWeightDistance(W,D);
num = size(D,2);%no. of objects
lw_wm=2*exp(lw)*num/sum(sum(distX));

save([folder_now path '\lw_wm.mat'],'lw_wm');


%%