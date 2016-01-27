%test LPT
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
addpath([folder_now,'\test']);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

level=5;

for i=1:level
    num=csvread([ 'l' num2str(i) '.csv']);
    D(:,:,i)=num;
end

[y, P, W, distX, evs]=LPS(D,2,2,0.8);
q=computeQ(distX,y);
sprintf('lq: %f', q);



%%