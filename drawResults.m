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
load(['.',path,'\Q.mat'],'Q');

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
saveas(h,['.',path,'\eta_weights.eps']);

%draw detailed k-c
h=figure('name','k_c_detail');
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
    saveas(h,['.',path,'\k_c_detail.eps']);
catch
end

%draw mean k-c

h=figure('name','k_c_mean');
hold on;

mdncm=reshape(mean(dncm,1),[length(k),length(c)]);

ymin=min(min(min(mdncm)));
ymax=max(max(max(mdncm)));

plot(k,mdncm,lineType{1});
xlabel('No. of nearest neighbors');
ylabel('Difference no. of clusters');
zlabel('No. of clusters');
axis([c(1) c(length(c)) ymin-10 ymax+10])

hold off;
try
    saveas(h,['.',path,'\k_c_mean.jpg']);
    saveas(h,['.',path,'\k_c_mean.eps']);
catch
end


%draw c-logWk

nc=unique(ncm);
[nc,~]=sort(nc);
[~,~,ncv]=find(nc);
nc=ncv;
%nc=ncv(ncv<=max(c));
mlw=zeros(length(eta),length(nc));
for i=1:length(eta)
    for j=1:length(nc)
        id=find(ncm(i,:,:)==nc(j));
        mlw(i,j)=sum(lw(i,id))/length(id);
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
saveas(h,['.',path,'\logWk.eps']);


%draw k-Q


figure('name','k_Q');
hold on;

ymin=min(min(min(mdncm)));
ymax=max(max(max(mdncm)));

h=plot(k,mean(mean(Q,3),1),lineType{1});
xlabel('No. of nearest neighbors');
ylabel('Moduality');

hold off;
try
    saveas(h,['.',path,'\k_Q.jpg']);
    saveas(h,['.',path,'\k_Q.eps']);
catch
end


h=figure('name','Q_eta');
sQ=zeros(length(eta),length(nc));
hold on;
for j=1:length(nc)
    sQ(:,j)=NaN;
    for i=1:length(eta)
        id=find(ncm(i,:,:)==nc(j));
        if ~isempty(id)
            sQ(i,j)=mean(Q(i,id));
        end
    end
    plot(eta,sQ(:,j),'k-o','color',rand(1,3));
end

hold off;
xlabel('\eta');
ylabel('Q');
legend (labelC, 'Location', 'EastOutside');
saveas(h,['.',path,'\Q_eta.jpg']);
saveas(h,['.',path,'\Q_eta.eps']);


h=figure('name','Q_mean_eta');
hold on;

sQ=mean(mean(Q,3),2);
plot(eta,sQ,lineType{1});

hold off;
xlabel('\eta');
ylabel('Q');
saveas(h,['.',path,'\Q_mean_eta.jpg']);
saveas(h,['.',path,'\Q_mean_eta.eps']);

%draw c_Q

nc=unique(ncm);
[nc,~]=sort(nc);
[~,~,ncv]=find(nc);
nc=ncv(ncv<=300);
%nc=ncv(ncv<=max(c));


h=figure('name','Q_detail');
hold on;
dQ=zeros(length(nc),1);
labelEta=cell(length(eta),1);
for i=1:length(eta)
    index=mod(i,length(lineType));
    if ~index
        index=length(lineType);
    end
    subplot(4,5,i);
    index=mod(i,length(lineType));
    if ~index
        index=length(lineType);
    end
    dQ(:,1)=NaN;
    for j=1:length(nc)
        id=find(ncm(i,:,:)==nc(j));
        dQ(j,1)=sum(Q(i,id))/length(id);
    end
    plot(nc,dQ(:,1),lineType{index});
    xlabel('No. of clusters');
    ylabel('Moduality');
end


hold off;
xlabel('No. of clusters');
ylabel('Moduality');
saveas(h,['.',path,'\Q_detail.jpg']);
saveas(h,['.',path,'\Q_detail.eps']);


h=figure('name','Q_eta');
sQ=zeros(length(eta),length(nc));
hold on;
for i=1:length(eta)
    
    sQ(i,:)=NaN;
    for j=1:length(nc)
        id=find(ncm(i,:,:)==nc(j));
        if ~isempty(id)
            sQ(i,j)=max(max(Q(i,id)));
        end
    end
    id=~isnan(sQ(i,:));
    labelEta{i}=['\eta=',num2str(eta(i))];
    plot(nc(id),sQ(i,id),'k-o','color',rand(1,3));
end

hold off;
xlabel('\eta');
ylabel('No. of clusters');
legend (labelEta, 'Location', 'EastOutside');
saveas(h,['.',path,'\Q_eta.jpg']);
saveas(h,['.',path,'\Q_eta.eps']);


h=figure('name','Q_mean');
hold on;
mQ=zeros(length(eta),length(nc));
for i=1:length(eta)
    for j=1:length(nc)
        id=find(ncm(i,:,:)==nc(j));
        mQ(i,j)=sum(Q(i,id))/length(id);
    end
    index=mod(i,length(lineType));
    if index==0
        index=length(lineType);
    end
    plot(nc,mQ(i,:),lineType{index});
end

hold off;
xlabel('No. of clusters');
ylabel('Moduality');
% hleg = legend(labelEta,'Location', 'EastOutside');

saveas(h,['.',path,'\Q_mean.jpg']);
saveas(h,['.',path,'\Q_mean.eps']);


h=figure('name','Q_max');
hold on;
maxQ=zeros(length(nc),1);
maxQ=NaN;
for j=1:length(nc)
    id=find(ncm==nc(j));
    if ~isempty(id)
        maxQ(j,1)=max(Q(id));
    end
end
id=~isnan(maxQ);
plot(nc(id),maxQ(id),lineType{1});
axis([ -inf inf 0 0.3])


hold off;
xlabel('No. of clusters');
ylabel('Moduality');
% hleg = legend(labelEta,'Location', 'EastOutside');

saveas(h,['.',path,'\Q_max_lpt.eps']);
saveas(h,['.',path,'\Q_max_lpt.jpg']);


%%
