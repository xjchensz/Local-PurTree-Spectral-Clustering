%test LPT
%input 5 csv files
%
%%
clc;
clear all;

folder_now = pwd;
path='\dis_1338';
subpath=[path,'\parts'];
addpath([folder_now, path]);


load(['.',subpath,'\nlw1.mat'],'nlw');
load(['.',subpath,'\ncm1.mat'],'ncm');
load(['.',subpath,'\wm1.mat'],'wm');
load(['.',subpath,'\Q1.mat'],'Q');
nlw1=nlw;
ncm1=ncm;
wm1=wm;
Q1=Q;

ed=4;
for i=2:ed
    load(['.',subpath,['\nlw', num2str(i), '.mat']],'nlw');
    load(['.',subpath,['\ncm',num2str(i),'.mat']],'ncm');
    load(['.',subpath,['\wm',num2str(i),'.mat']],'wm');
    load(['.',subpath,['\Q',num2str(i),'.mat']],'Q');
    nlw1=[nlw1;nlw];
    ncm1=[ncm1;ncm];
    wm1=[wm1;wm];
    Q1=[Q1;Q];
end

nlw=nlw1;
ncm=ncm1;
wm=wm1;
Q=Q1;

save(['.',path,'\nlw.mat'],'nlw');
save(['.',path,'\ncm.mat'],'ncm');
save(['.',path,'\wm.mat'],'wm');
save(['.',path,'\Q.mat'],'Q');

%%