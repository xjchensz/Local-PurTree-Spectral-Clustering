%%
clc;
clear all;
close all;

folder_now = pwd;

path='.';

files = cell(2,2);

files{1,1}='\QN.csv';
files{1,2}='QN';

files{2,1}='\QR.csv';
files{2,2}='QR';


lineType={'b-*','r-*','k-*','c-*','g-*','m-*'};
figure_FontSize=20;
legend_FondSize=20;

for i=1:size(files,1)
            
    Q=csvread([path, files{i,1}]);
    
    % number of clusters
    c=Q(1,2:size(Q,2));
    Q=Q(2:size(Q,1),:);
    
    % gamma
    gamma=Q(1:size(Q,1),1);
    Q=Q(:,2:size(Q,2));
    
    Q(Q==0)=NaN;
    
    % Q
    h=figure('name',['Q_',files{i,2}]);
    set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
    set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Horizontal','right');
    set(findobj('FontSize',10),'FontSize',figure_FontSize);
    hold on;
    labelGamma=cell(length(gamma),1);
    
    for j=1:length(gamma)
        plot(c,Q(j,:),lineType{j});
        labelGamma{j}=['\gamma=',num2str(gamma(j))];
    end
    axis([ 5 150 0 0.15])
    
    grid on;
    hold off;
    xlabel('c');
    ylabel('Q');
    hl=legend(labelGamma);
    set(hl,'Fontsize',legend_FondSize);
    
    saveas(h,[path,'\Q_', files{i,2}, '.eps'],'psc2');
    
    % Q_max
    figure('name',['Qmax_',files{i,2}]);
    set(findobj('FontSize',10),'FontSize',figure_FontSize);
    hold on;
    maxQ=zeros(length(c),1);
    
    for j=1:length(c)
        maxQ(j,1)=max(Q(:,j));
    end
    h=plot(c,maxQ,lineType{1});
    axis([ 5 150 0 0.15])
    
    grid on;
    hold off;
    xlabel('c');
    ylabel('Q');
    
    saveas(h,[path,'\Q_max_', files{i,2}, '.eps'],'psc2');
end



%%
