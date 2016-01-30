%%
clc;
clear all;
close all;

folder_now = pwd;
path='\dis_1338';
addpath([folder_now, path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\lw.mat'],'lw');
load(['.',path,'\ncm.mat'],'ncm');
load(['.',path,'\wm.mat'],'wm');
load(['.',path,'\Q.mat'],'Q');

id=find(ncm<=0);
ncm(id)=nan;
Q(id)=nan;


level = size(wm,3);


% nearest neighbors
k=5:5:50;

% number of clusters
c=5:50;


nc=unique(ncm);
[nc,~]=sort(nc);
[~,~,ncv]=find(nc);
nc=ncv(ncv<=300);

maxQ=zeros(length(nc),1);
maxQ=NaN;
for j=1:length(nc)
    id=find(ncm==nc(j));
    if ~isempty(id)
        maxQ(j,1)=max(Q(id));
    end
end

[~,idx]=sort(maxQ);
len=length(idx);
lo=10;
for i=1:lo
    id=idx(len-i+1);
    sprintf('c=%d, Q=%d', nc(id),maxQ(id))
end

%%
