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


lineType={'b-*','r-+','k-o','y-x','g-*','c-.','m-s'};

%draw k-weights
h=figure('name','k-Wegiths');
hold on;
labelW=cell(level,1);

mwm=mean(wm,2);
for i=1:level
    plot(k,mwm(:,1,i),lineType{i});
    labelW{i}=['w',num2str(i)];
end
hold off;
xlabel('k');
ylabel('Weights');
legend(labelW);
saveas(h,['.',path,'\k_weights.jpg']);
saveas(h,['.',path,'\k_weights.eps']);

%draw c-weights
h=figure('name','c-Wegiths');
hold on;
labelW=cell(level,1);

mwm=mean(wm,3);
for i=1:level
    plot(k,mwm(:,1,i),lineType{i});
    labelW{i}=['w',num2str(i)];
end
hold off;
xlabel('c');
ylabel('Weights');
legend(labelW);
saveas(h,['.',path,'\c_weights.jpg']);
saveas(h,['.',path,'\c_weights.eps']);


%draw k-c

h=figure('name','k_c');
hold on;

dncm=repmat(c',[1,length(k)]);
dncm=ncm-dncm;

plot(k,ncm,lineType{1});
xlabel('k');
ylabel('Difference no. of clusters');

hold off;
try
    saveas(h,['.',path,'\k_c.jpg']);
    saveas(h,['.',path,'\k_c.eps']);
catch
end



%draw k-Q


figure('name','k_Q');
hold on;

h=plot(k,Q,lineType{1});
xlabel('No. of nearest neighbors');
ylabel('Moduality');

hold off;
try
    saveas(h,['.',path,'\k_Q.jpg']);
    saveas(h,['.',path,'\k_Q.eps']);
catch
end


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
