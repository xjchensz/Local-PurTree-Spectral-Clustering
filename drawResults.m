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
labelW=cell(level,1);

mwm=mean(mean(wm,2),3);
for i=1:level
    h=plot(eta,mwm(:,1,1,i),lineType{i});
    labelW{i}=['w',num2str(i)];
end
hold off;
xlabel('\eta');
ylabel('Weights');
legend(labelW);
saveas(h,['.',path,'\eta_weights.jpg']);

%draw detailed k-c
h=figure('name','No. of clusters');
hold on;
labelC=cell(length(c),1);
for j=1:length(c)
    labelC{j}=['c=',num2str(c(j))];
end


dncm=permute(repmat(repmat(c',[1,length(k)]),[1,1,length(eta)]),[3,2,1]);
dncm=ncm-dncm;

ymin=min(min(min(dncm)));
ymax=max(max(max(dncm)));

for i=1:length(eta)
    %surf(repmat(k',[1,length(c)]),repmat(c,[length(k),1]),reshape(ncm(i,:,:),[length(k),length(c)]));
    index=mod(i,length(lineType));
    if ~index
        index=length(lineType);
    end
    subplot(4,5,i);
    %surf(repmat(k',[1,length(c)]),repmat(c,[length(k),1]),reshape(ncm(i,:,:),[length(k),length(c)]));
    index=mod(i,length(lineType));
    if ~index
        index=length(lineType);
    end
    h=plot(k,reshape(dncm(i,:,:),[size(dncm,2),size(dncm,3)]),lineType{index});
    xlabel('No. of nearest neighbors');
    ylabel('Difference no. of clusters');
    zlabel('No. of clusters');
    axis([c(1) c(length(c)) ymin-10 ymax+10])
    %legend(labelC);
end


hold off;
try
    saveas(h,['.',path,'\k_c_detail.jpg']);
catch
end

%draw mean k-c

h=figure('name','No. of clusters');
hold on;

mdncm=reshape(mean(dncm,1),[length(k),length(c)]);

ymin=min(min(min(mdncm)));
ymax=max(max(max(mdncm)));

h=plot(k,mdncm,lineType{1});
xlabel('No. of nearest neighbors');
ylabel('Difference no. of clusters');
zlabel('No. of clusters');
axis([c(1) c(length(c)) ymin-10 ymax+10])

hold off;
try
    saveas(h,['.',path,'\k_c_mean.jpg']);
catch
end

%draw c-logWk


nc=unique(ncm);
[nc,~]=sort(nc);
[~,~,ncv]=find(nc);
nc=ncv(ncv<=max(c));
mlw=zeros(length(eta),length(nc));
for i=1:length(eta)
    for j=1:length(nc)
        id=find(ncm==nc(j));
        mlw(i,j)=sum(lw(id))/length(id);
    end
end

figure('name','logWk');
hold on;


for i=1:length(eta)
    index=mod(i,length(lineType));
    if index==0
        index=length(lineType);
    end
    h=plot(nc,mlw(i,:),lineType{index});
end
hold off;
xlabel('No. of clusters');
ylabel('Log(Wk)');
% hleg = legend(labelEta,'Location', 'EastOutside');

saveas(h,['.',path,'\logWk.jpg']);

%%
