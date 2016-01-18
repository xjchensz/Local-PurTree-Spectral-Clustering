%test LPT
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
path='\dis_5352';
name='\dis_5352';
addpath([folder_now,path]);

level=4;

for i=1:level
    num=csvread([ 'l_' num2str(i) '.csv']);
    D(:,:,i)=num;
end

path=['.',path,name,'.mat'];

save(path,'D');

%%