%test computeLogWk
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
base=[folder_now,'\sacalability'];

addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

path=cell(10,1);
dir='F:\Í¬²½\workspaces\Graph\ClusteringSemanticTree\sample2\sd2';
for i=1:length(path)
    path{i}=[dir,'\data',num2str(i),'\dis'];
end


% nearest neighbors
k=20;

% number of clusters
c=5:5:50;

level=4;


Q= zeros(length(path)+1,length(c)+1);
Q(1,:)=[0,c];
for i=1:length(path)
    %load data
    Q(i+1,1)=i;
    for j=1:level
        num=csvread([path{i},'\l',num2str(j),'.csv']);
        D(:,:,j)=num;
    end
    sprintf('The number of objects in data%d is: %d', i, size(D,1))
    
    for j=1:length(c)
        try
            [y, ~, ~, distX, ~]=LPS(D,c(j),k);
            Q(i+1,j+1)=computeQ(distX,y);
        catch
            continue;
        end
    end
    clear D;
    sprintf('Q: %f', max(Q(i+1,2:length(c)+1)))
end

save([base '\Q.mat'],'Q');



%%