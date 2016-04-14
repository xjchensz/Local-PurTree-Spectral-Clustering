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

files=cell(6,2);

files{1,1}='\D1';
files{1,2}='5';

files{2,1}='\D2';
files{2,2}='3';

files{3,1}='\dis_1338';
files{3,2}='4';

files{4,1}='\D4';
files{4,2}='4';

files{5,1}='\D5';
files{5,2}='4';

files{6,1}='\D6';
files{6,2}='4';

% nearest neighbors
k=10:10:100;

% number of cl
c=5:5:100;


numData=[5];

index=2;
sprintf('Index: %d',index)
di=1:size(files,1);

if index>0
    start=0;
    for i=1:index-1
        start=start+numData(i);
    end
    di=di(start+1:start+numData(index));
end


Q= zeros(length(di),length(c),length(k));
nlw= zeros(length(di),length(c),length(k));
for i=1:length(di)
    %load data
    D=csvread([folder_now files{di(i),1},'\dis_jaccard.csv']);
    sprintf('The number of objects in data%d is: %d', i, size(D,1))
    
    maxQ=-10;
    maxNLW=-10;
    for l=1:length(c)
        for j=1:length(k)
             try
                [y, ~, ~]=CAN(D,c(l),k(j));
                q=computeQ(D,y);
                Q(i,l,j)=q;
                if q>maxQ
                    maxQ=q;
                    sprintf('Q: %f', q)
                end
                nw=NLW(D,y);
                nlw(i,l,j)=nw;
                if nw>maxNLW
                    maxNLW=nw;
                    sprintf('NLW: %f', nw)
                end
             catch err
                 disp(err);
                 continue;
             end
        end
    end
    clear D;
    sprintf('Q: %f', maxQ);
    sprintf('NLW: %f', maxNLW);
end

if index>0
    save([base '\Q' num2str(index) '_can.mat'],'Q');
    save([base '\nlw' num2str(index) '_can.mat'],'nlw');
else
    save([base '\Q_can.mat'],'Q');
    save([base '\nlw_can.mat'],'nlw');
end


%%