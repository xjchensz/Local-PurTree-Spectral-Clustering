%test LPT
%input 5 csv files
%
%%
clc;
%clear all;

folder_now = pwd;
path='\dis_1338';
addpath([folder_now,path]);
addpath([folder_now, '\functions']);
addpath([folder_now, '\draw']);

load(['.',path,'\dis_1338.mat'],'D');
level = size(D,3);
sprintf('The number of objects is: %d', size(D,1));


c=50;
[y, P, W, distX, evs]=LPT(D,c,50,0.8);

sprintf('LogWk: %d', logWK(distX,y))
draw_Dist(y,distX);
draw_Weights(W);
draw_P(y,P);



%%