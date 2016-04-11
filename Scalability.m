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

path=cell(10,2);

files{1,1}='\D1\dis_202';
files{1,2}='5';

files{2,1}='\D2\dis_795';
files{2,2}='3';

files{3,1}='\D4\dis_2676';
files{3,2}='4';

files{4,1}='\D5\dis_5352';
files{4,2}='4';


% nearest neighbors
k=10:10:100;

% number of clusters
c=10:10:100;


numData=[1 1 1 1];

index=2;
sprintf('Index: %d',index)
di=1:4;

if index>0
    start=0;
    for i=1:index-1
        start=start+numData(i);
    end
    di=di(start+1:start+numData(index));
end


Q= zeros(length(di),1);
nlw= zeros(length(di),1);
for i=1:length(di)
    %load data
    level=str2num(files{di(i),2});
    for j=1:level
        da=csvread([folder_now files{di(i),1},'\l',num2str(j),'.csv']);
        D(:,:,j)=da;
    end
    sprintf('The number of objects in data%d is: %d', i, size(D,1))
    
    maxQ=-10;
    maxNLW=-10;
    for l=1:length(c)
        for j=1:length(k)
             try
                [y, ~, ~, distX, ~]=LPS(D,c(l),k(j));
                q=computeQ(distX,y);
                if q>maxQ
                    maxQ=q;
                    sprintf('Q: %f', maxQ);
                end
                nw=NLW(distX,y);
                if nw>maxNLW
                    maxNLW=nw;
                    sprintf('NLW: %f', maxNLW);
                end
             catch err
                 disp(err);
                 continue;
             end
        end
    end
    clear D;
    Q(i)=maxQ;
    sprintf('Q: %f', maxQ);
    nlw(i)=maxNLW;
    sprintf('NLW: %f', maxNLW);
end

if index>0
    save([base '\Q_lps' num2str(index) '.mat'],'Q');
    save([base '\nlw' num2str(index) '_lps.mat'],'nlw');
else
    save([base '\Q_lps.mat'],'Q');
    save([base '\nlw_lps.mat'],'nlw');
end


%%