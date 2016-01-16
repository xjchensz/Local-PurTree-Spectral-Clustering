%test computeLogWk
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
addpath([folder_now,'\real_data']);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);


level=5;

for i=1:level
    num=csvread([ 'l' num2str(i) '.csv']);
    D(:,:,i)=num;
end
sprintf('The number of objects is: %d', size(D,1))

start=5;
ed=40;
c=start:ed;
k=50;
eta=0.8;
lw=zeros(ed-start+1);
for i=1:length(c)
    [y, ~, ~, distX, ~]=LPT(D,c(i),k,eta);
    nc=length(unique(y));
    if nc>=start & nc<=ed
        lw(nc-start+1)=logWK(distX,y);
    end
end

figure('name','Log(Wk)'); 
plot(c,lw,'b-*')
xlabel('no. of clusters')
ylabel('Log(Wk)')





%%