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

files{1,1}='\D1\dis_202';
files{1,2}='5';

files{2,1}='\D2\dis_795';
files{2,2}='3';

files{3,1}='\dis_1338\dis_1338';
files{3,2}='4';

files{4,1}='\D4\dis_1500';
files{4,2}='4';

files{5,1}='\D5\dis_2000';
files{5,2}='4';

files{6,1}='\D6\dis_2676';
files{7,2}='4';

% nearest neighbors
k=10:10:100;

% number of cl
c=5:5:100;


numData=[3 1 1];

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
SI=zeros(length(di),length(c),length(k));
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
    maxSI=-1000;
    for l=1:length(c)
        for j=1:length(k)
             try
                [y, ~, ~, distX, ~]=LPS(D,c(l),k(j));
                q=computeQ(distX,y);
                Q(i,l,j)=q;
                if q>maxQ
                    maxQ=q;
                    sprintf('Q: %f', q)
                end
                nw=NLW(distX,y);
                nlw(i,l,j)=nw;
                if nw>maxNLW
                    maxNLW=nw;
                    sprintf('NLW: %f', nw)
                end
                si=SilhouetteIndex(distX,y);
                SI(i,l,j)=si;
                if si>maxSI
                    maxSI=si;
                    sprintf('SI: %f', si)
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
    save([base '\Q' num2str(index) '_lps.mat'],'Q');
    save([base '\nlw' num2str(index) '_lps.mat'],'nlw');
else
    save([base '\Q_lps.mat'],'Q');
    save([base '\nlw_lps.mat'],'nlw');
end


%%