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
k=95;
c=30;

[y, ~, W, distX, ~]=LPS(D,c,k,1);
Q=computeQ(distX,y);

dlmwrite([folder_now path '\origin.csv'],distX);


cluster=unique(y);
numC=zeros(length(y),1);
for i=1:length(cluster)
    numC(i)=length(find(y==cluster(i)));
end

[~,I]=sort(numC);
I=I(end:-1:1);
nidx=zeros(length(y),1);
index=1;
sta=zeros(length(y),2);
for i=1:length(cluster)
    sta(i,1)=I(i);
    sta(i,2)= numC(I(i));
    idx=find(y==cluster(I(i)));
    nidx(index:index+length(idx)-1,1)=idx(:,1);
    index=index+length(idx);
end

dlmwrite([folder_now path '\clustered.csv'],distX(nidx,nidx));
dlmwrite([folder_now path '\clustering.csv'],reshape(y,length(y),1));

dlmwrite([folder_now path '\sta.csv'],sta);

%%