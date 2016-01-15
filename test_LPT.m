%test LPT
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
addpath([folder_now,'\data']);

level=5;

for i=1:level
    num=csvread([ 'l' num2str(i) '.csv']);
    D(:,:,i)=num;
end

testD=LPT(D,2,15,1);



%%