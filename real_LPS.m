%test LPT
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
addpath([folder_now,'\real_data']);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);


level=5;

for i=1:level
    num=csvread([ 'l' num2str(i) '.csv']);
    D(:,:,i)=num;
end

sprintf('The number of objects is: %d', size(D,1))

c=50;
[y, P, W, distX, evs]=LPS(D,c,50);

sprintf('LogWk: %d', logWK(distX,y))
draw_Dist(y,distX);
draw_Weights(W);
draw_P(y,P);



%%