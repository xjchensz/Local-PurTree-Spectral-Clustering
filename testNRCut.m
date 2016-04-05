%test compute ncm Q
%input 4 csv files
%
%%
clc;

folder_now = pwd;
path='\dis_Q';
name='\dis_Q';
addpath([folder_now, path]);
addpath([folder_now, '\functions']);


files = cell(4,2);
files{1,1}='\distance_pt_0.0.csv';
files{1,2}='0.0';

files{2,1}='\distance_pt_0.2.csv';
files{2,2}='0.2';

files{3,1}='\distance_pt_0.8.csv';
files{3,2}='0.8';

files{4,1}='\distance_pt_1.0.csv';
files{4,2}='1.0';

% number of clusters
c=5:150;

Nncm=zeros(size(files,1),length(c));
QN=zeros(size(files,1),length(c));
Rncm=zeros(size(files,1),length(c));
QR=zeros(size(files,1),length(c));

path=[folder_now,path];
for j=1:size(files,1)
    D=csvread([path,files{j,1}]);
    sprintf('The number of objects is: %d', size(D,1))
    for i=1:length(c)
        try
            [y1]=NCut(D,c(i));
            [y2]=RCut(D,c(i));
        catch
            continue;
        end
        Nncm(j,i)=length(unique(y1));
        QN(j,i)=computeQ(D,y1);
        sprintf('QN: %d', QN(j,i))
        Rncm(j,i)=length(unique(y2));
        QR(j,i)=computeQ(D,y2);
        sprintf('QR: %d', QN(j,i))
    end
end

save([path '\ncm_NCut.mat'],'Nncm');
save([path '\Q_NCut'  files{j,2} '.mat'],'QN');

save([path '\ncm_RCut.mat'],'Rncm');
save([path '\Q_RCut'  files{j,2} '.mat'],'QR');



%%