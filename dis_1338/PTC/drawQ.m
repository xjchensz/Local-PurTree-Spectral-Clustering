%%
clc;
%clear all;

folder_now = pwd;

path='.';

Q=csvread([path, '\Q.csv']);


% number of clusters
c=Q(1,2:size(Q,2));
Q=Q(2:size(Q,1),:);

% eta
gamma=Q(1:size(Q,1),1);
Q=Q(:,2:size(Q,2));


lineType={'b-o','r-o','k-o','y-o','g-o','c-o','m-o'};


%draw c_Q


h=figure('name','Q_gamma_ptc');
hold on;
labelGamma=cell(length(gamma),1);
gammaAxis=gamma;
for i=1:length(gamma)
    index=mod(i,length(lineType));
    if ~index
        index=length(lineType);
    end
    labelGamma{i}=['\gamma=',num2str(gamma(i))];
    gammaAxis(i)=i;
end

plot(gammaAxis,Q,lineType{1});
xlabel('\gamma');
ylabel('Moduality');
title('Q-\gamma');
set(gca,'XTick',gammaAxis);
set(gca,'XTickLabel',gamma);

hold off;
saveas(h,[path,'\Q_gamma_ptc.eps']);


h=figure('name','Q_gamma_mean_ptc');
hold on;
labelGamma=cell(length(gamma),1);
gammaAxis=gamma;
for i=1:length(gamma)
    index=mod(i,length(lineType));
    if ~index
        index=length(lineType);
    end
    labelGamma{i}=['\gamma=',num2str(gamma(i))];
    gammaAxis(i)=i;
end

plot(gammaAxis,mean(Q,2),lineType{1});
xlabel('\gamma');
ylabel('Moduality');
title('Q-\gamma');
set(gca,'XTick',gammaAxis);
set(gca,'XTickLabel',gamma);

hold off;
saveas(h,[path,'\Q_gamma_mean_ptc.eps']);


figure('name','Q_mean');
hold on;
meanQ=zeros(length(c),1);

for j=1:length(c)
    meanQ(j,1)=mean(Q(:,j));
end
h=plot(c,meanQ,lineType{1});


hold off;
xlabel('No. of clusters');
ylabel('Moduality');
saveas(h,[path,'\Q_mean.eps']);




figure('name','Q_max');
hold on;
maxQ=zeros(length(c),1);

for j=1:length(c)
    maxQ(j,1)=max(Q(:,j));
end
h=plot(c,maxQ,lineType{1});
axis([ -inf inf 0 0.25])

hold off;
xlabel('No. of clusters');
ylabel('Moduality');
% hleg = legend(labelEta,'Location', 'EastOutside');

saveas(h,[path,'\Q_max_ptc.eps']);


%%
