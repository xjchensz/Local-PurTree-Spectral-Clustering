%test computeLogWk
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
path='\dis_1338';
addpath([folder_now, path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\lw.mat'],'lw');
load(['.',path,'\ncm.mat'],'ncm');
load(['.',path,'\wm.mat'],'wm');

level = size(wm,4);


% nearest neighbors
k=5:5:50;

% number of clusters
c=5:50;

% eta
eta=0.1:0.1:2;


lineType={'b-*','r-+','k-o','y-x','g-*','c-.','m-s'};

%draw eta-weights
figure('name','Wegiths');
hold on;
labelC=cell(level,1);

mwm=mean(mean(wm,2),3);
for i=1:level
    h=plot(eta,mwm(:,1,1,i),lineType{i});
    labelC{i}=['w',num2str(i)];
end
hold off;
xlabel('\eta');
ylabel('Weights');
legend(labelC);
saveas(h,['.',path,'\eta_weights.jpg']);

%draw k-c
h=figure('name','No. of clusters');

for i=1:length(eta)
    
    surf(repmat(k',[1,length(c)]),repmat(c,[length(k),1]),reshape(ncm(i,:,:),[length(k),length(c)]));
 
    
    xlabel('No. of nearest neighbors');
    ylabel('Expected no. of clusters');
    zlabel('No. of clusters');
end

saveas(h,['.',path,'\k_c.jpg']);

%draw c-logWk


labelC=cell(length(eta),1);

nc=unique(ncm);
[nc,~]=sort(nc);
[~,~,ncv]=find(nc);
nc=ncv;
mlw=zeros(length(eta),length(nc));
for i=1:length(eta)
    for j=1:length(nc)
        id=find(ncm==nc(j));
        mlw(i,j)=sum(lw(id))/length(id);
    end
end


figure('name','logWk');
hold on;
labelC=cell(length(eta),1);

for i=1:length(eta)
    index=mod(i,length(lineType));
    if index==0
        index=length(lineType);
    end
    h=plot(nc,mlw(i,:),lineType{index});
    labelC{i}=['\eta=',num2str(eta(i))];
end
hold off;
xlabel('No. of clusters');
ylabel('Log(Wk)');
legend(labelC);
saveas(h,['.',path,'\logWk.jpg']);




%%