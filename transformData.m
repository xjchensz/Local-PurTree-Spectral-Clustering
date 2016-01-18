%test LPT
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
path='\dis_1338';
name='\dis_1338';
addpath([folder_now,path]);

level=4;

for i=1:level
    num=csvread([ 'l' num2str(i) '.csv']);
    D(:,:,i)=num;
end

path=['.',path,name,'.mat'];

save(path,'D');

%%