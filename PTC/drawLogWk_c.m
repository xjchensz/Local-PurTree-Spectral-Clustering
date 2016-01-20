%test computeLogWk
%input 1 csv files
%
%%
clc;
clear all;

folder_now = pwd;
addpath(folder_now);

logWk=csvread([folder_now '\logWk.csv']);
gamma=logWk(2:size(logWk,1),1);
logWk=logWk(:,2:size(logWk,2));
c=logWk(1,:);
logWk=logWk(2:size(logWk,1),:);


lineType={'b-*','r-+','k-o','y-x','g-*','c-.','m-s'};
labelGamma=cell(length(gamma),1);


h=figure('name','LogWk');
hold on;

for i=1:length(gamma)
    labelGamma{i}=['\gamma=',num2str(c(i))];
    index=mod(i,length(lineType));
    if index==0
        index=length(lineType);
    end
    plot(c,logWk(i,:),lineType{index});
end



hold off;
xlabel('No. of clusters');
ylabel('LogWk');
legend(labelGamma);
saveas(h,[folder_now,'\logWk_c.jpg']);




%%