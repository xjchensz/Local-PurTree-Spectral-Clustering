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

eta=0.1:0.1:2;
c=20;
k=50;
wm=zeros(length(eta),level);
lw=zeros(length(eta),1);
for i=1:length(eta)
    [y, ~, W, distX, ~]=LPT(D,c,k,eta(i));
    wm(i,:)=W';
    lw(i,1)=logWK(distX,y);
end


figure('name','Wegiths'); 
plot(eta,wm,'b-*');
xlabel('\eta');
ylabel('Weights');


figure('name','Log(Wk)'); 
plot(eta,lw,'b-*')
xlabel('\eta')
ylabel('Log(Wk)')



%%