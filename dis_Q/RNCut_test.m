%%
clc;
clear all;
close all;

folder_now = pwd;

path='.';

files = cell(5,2);

% files{1,1}='\ncm_NCut.mat';
% files{1,2}='Nncm';

files{1,1}='\Q_NCut1.0.mat';
files{1,2}='QN';

% 
% files{3,1}='\ncm_RCut.mat';
% files{3,2}='Rncm';
% 
% files{4,1}='\Q_RCut1.0.mat';
% files{4,2}='QR';

lineType={'b-*','r-*','k-*','c-*','g-*','m-*'};
figure_FontSize=20;
legend_FondSize=20;

for i=1:size(files,1)
    
    example = matfile([path, files{i,1}]);
    [nrows, ncols] = size(example,files{i,2});
    varlist = who(example);
    varName = varlist{i};
    for i=1:nrows
        for j=1:ncols
            Q(i,j)=example.(varName)(i,j);
        end
    end 
    
    % number of clusters
    c=1:ncols;
   
    % gamma
    gamma=[0.0 0.2 0.8 1.0];
    
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
