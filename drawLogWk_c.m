%test computeLogWk
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
path='\dis_5352';
addpath([folder_now,path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\dis_5352.mat'],'D');
level = size(D,3);
sprintf('The number of objects is: %d', size(D,1))

start=5;
ed=50;
c=start:ed;
k=50;
eta=0.8;
lw=zeros(1,ed-start+1);
for i=1:length(c)
    [y, ~, ~, distX, ~]=LPT(D,c(i),k,eta);
    nc=length(unique(y));
    if nc>=start && nc<=ed
        lw(1,nc-start+1)=logWK(distX,y);
    end
end

idx=find(lw>0);
c=c(idx);
lw=lw(idx);

figure('name','Log(Wk)'); 
plot(c,lw,'b-*')
xlabel('no. of clusters')
ylabel('Log(Wk)')





%%