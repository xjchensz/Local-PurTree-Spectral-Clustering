%%
clc;
clear all;
close all;

folder_now = pwd;
path='\dis_1338';
addpath([folder_now, path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\lw.mat'],'lw');
load(['.',path,'\ncm.mat'],'ncm');
load(['.',path,'\wm.mat'],'wm');
load(['.',path,'\Q.mat'],'Q');

id=find(ncm<=0);
ncm(id)=nan;
Q(id)=nan;


level = size(wm,3);


% nearest neighbors
k=5:5:50;

% number of clusters
c=5:150;

nc=unique(ncm);
[nc,~]=sort(nc);
[~,~,ncv]=find(nc);
nc=ncv(ncv<=150);

lineType={'b-*','r-+','k-o','c-x','g-*','c-.','m-s'};

figure_FontSize=20;
legend_FondSize=20;

%draw k-weights
h=figure('name','k-Wegiths');
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Horizontal','right');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
hold on;
labelW=cell(level,1);

mwm=mean(wm,2);
for i=1:level
    plot(k,mwm(:,1,i),lineType{i});
    labelW{i}=['\omega',num2str(i)];
end
grid on;
hold off;
xlabel('k');
ylabel('Weights');
hl=legend(labelW,'Location','NorthOutside');
set(hl,'Fontsize',legend_FondSize);
set(hl,'Orientation','horizon');
set(gca,'ylim',[0 0.6]);

saveas(h,['.',path,'\k_weights.jpg']);
saveas(h,['.',path,'\k_weights.eps'],'psc2');


%draw c-weights
h=figure('name','c-Wegiths');
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Horizontal','right');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(gca,'ylim',[0 0.6]);
hold on;
mwm=zeros(length(nc),level);

for j=1:length(nc)
    [row, col]=find(ncm==nc(j));
    mwm(j,:)=mean(mean(wm(row,col,:),2),1);
end

for i=1:level
    plot(nc,mwm(:,i),lineType{i});
end
grid on;
hold off;
xlabel('c');
ylabel('Weights');
hl=legend(labelW,'Location','NorthOutside');
set(hl,'Fontsize',legend_FondSize);
set(hl,'Orientation','horizon');

saveas(h,['.',path,'\c_weights.jpg']);
saveas(h,['.',path,'\c_weights.eps'],'psc2');


%draw k-c

h=figure('name','k_c');
hold on;


dncm=repmat(c,[length(k),1]);
dncm=ncm-dncm;

plot(k,ncm,lineType{1});
xlabel('k');
ylabel('Difference no. of clusters');

grid on;
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

grid on;
hold off;
try
    saveas(h,['.',path,'\k_Q.jpg']);
    saveas(h,['.',path,'\k_Q.eps']);
catch
end


%draw c_Q


h=figure('name','c_Qmean');
hold on;
mQ=zeros(length(nc),1);
mQ=NaN;
for j=1:length(nc)
    id=find(ncm==nc(j));
    mQ(j,1)=sum(Q(id))/length(id);
end
plot(nc,mQ,lineType{1});

grid on;
hold off;
xlabel('No. of clusters');
ylabel('Moduality');


saveas(h,['.',path,'\c_Qmean.jpg']);
saveas(h,['.',path,'\c_Qmean.eps']);


h=figure('name','c_Qmax');
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Horizontal','right');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
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
axis([ 5 150 0 0.15])

grid on;
hold off;
xlabel('c');
ylabel('Moduality');

saveas(h,['.',path,'\c_Qmax_lpt.eps'],'psc2');
saveas(h,['.',path,'\c_Qmax_lpt.jpg']);

%%
