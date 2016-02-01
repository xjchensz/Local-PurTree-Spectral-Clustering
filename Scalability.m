%test computeLogWk
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
base=folder_now;

addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

path=cell(10,1);
dir='F:\Í¬²½\workspaces\Graph\ClusteringSemanticTree\sample2\sd2';
for i=1:length(path)
    path{i}=[dir,'\data',num2str(i),'\dis'];
end


% nearest neighbors
k=10:5:50;

% number of clusters
c=5:5:50;

level=4;


Q= zeros(length(path)+1,length(c)+1);
Q(1,:)=[0,c];
for i=1:5
    %load data
    Q(i+1,1)=i;
    for j=1:level
        num=csvread([path{i},'\l',num2str(j),'.csv']);
        D(:,:,j)=num;
    end
    sprintf('The number of objects in data%d is: %d', i, size(D,1))
    
    
    for l=1:length(c)
        maxQ=-10;
        for j=1:length(k)
            try
                [y, ~, ~, distX, ~]=LPS(D,c(l),k(j));
                q=computeQ(distX,y);
                if q>maxQ
                    maxQ=q;
                end
            catch
                continue;
            end
        end
        Q(i+1,l+1)=maxQ;
    end
    clear D;
    sprintf('Q: %f', max(Q(i+1,2:length(c)+1)))
end

save([base '\Q_lps.mat'],'Q');



%%