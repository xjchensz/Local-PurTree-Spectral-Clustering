%test LPT
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
path='\real_data';
name='\real_data';
addpath([folder_now,path]);

level=5;

for i=1:level
    num=csvread([ 'l' num2str(i) '.csv']);
    D(:,:,i)=num;
end

path=['.',path,name,'.mat'];

save(path,'D');

%%