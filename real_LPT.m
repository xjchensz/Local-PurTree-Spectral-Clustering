%test LPT
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
addpath([folder_now,'\real_data']);

level=5;

for i=1:level
    num=csvread([ num2str(i) '_level_distance_.csv']);
    D(:,:,i)=num;
end

sprintf('The number of objects is: %d', size(D,1))

[y, P, W, evs]=LPT(D,20,15,0,1);
y;
W;


%%