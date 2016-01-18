%test computeLogWk
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
path='\dis_1338';
addpath([folder_now,path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\dis_1338.mat'],'D');
level = size(D,3);
sprintf('The number of objects is: %d', size(D,1));

start=5;
ed=100;
k=start:5:ed;
c=20:5:50;
lineType={'b-*','r-+','k-o','y-x','g-*','c-.','m-s'};
eta=0.8;
lw=zeros(length(c),length(k));
nc=zeros(length(c),length(k));
labelC=cell(length(c),1);
for i=1:length(c)
    labelC{i}=['c=',num2str(c(i))];
    for j=1:length(k)
        [y, ~, ~, distX, ~]=LPT(D,c(i),k(j),eta);
        lw(i,j)=logWK(distX,y);
        nc(i,j)=length(unique(y));
    end
end

figure('name','No. of recovered clusters');
hold on;
for i=1:length(c)
   h=plot(k,nc(i,:),lineType{i}); 
end
hold off;
xlabel('No. of neighbors');
ylabel('No. of clusters');
legend(labelC);
saveas(h,['.',path,'\k_c.jpg']);

figure('name','Log(Wk)'); 
hold on;
for i=1:length(c)
   h=plot(k,lw(i,:),lineType{i}); 
end
hold off;
xlabel('No. of neighbors');
ylabel('Log(Wk)');
hl=legend(labelC,'Location','SouthEast');
set(hl,'Box','off');
saveas(h,['.',path,'\k_lw.jpg']);




%%