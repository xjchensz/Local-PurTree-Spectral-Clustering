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
k=80;
c=10;

[y, ~, W, distX, ~]=LPS(D,c,k,1,1);

dlmwrite([folder_now path '\origin.csv'],distX);

cluster=unique(y);
nidx=zeros(length(y),1);
index=1;
for i=1:length(cluster)
    idx=find(y==cluster(i));
    nidx(index:index+length(idx)-1,1)=idx(:,1);
    index=index+length(idx);
end

dlmwrite([folder_now path '\clustered.csv'],distX(nidx,nidx));


%%