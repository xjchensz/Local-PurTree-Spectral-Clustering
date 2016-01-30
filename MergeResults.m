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


load(['.',subpath,'\lw1.mat'],'lw');
load(['.',subpath,'\ncm1.mat'],'ncm');
load(['.',subpath,'\wm1.mat'],'wm');
load(['.',subpath,'\Q1.mat'],'Q');
lw1=lw;
ncm1=ncm;
wm1=wm;
Q1=Q;

ed=2;
for i=2:ed
    load(['.',subpath,['\lw', num2str(i), '.mat']],'lw');
    load(['.',subpath,['\ncm',num2str(i),'.mat']],'ncm');
    load(['.',subpath,['\wm',num2str(i),'.mat']],'wm');
    load(['.',subpath,['\Q',num2str(i),'.mat']],'Q');
    lw1=[lw1;lw];
    ncm1=[ncm1;ncm];
    wm1=[wm1;wm];
    Q1=[Q1;Q];
end

lw=lw1;
ncm=ncm1;
wm=wm1;
Q=Q1;

save(['.',path,'\lw.mat'],'lw');
save(['.',path,'\ncm.mat'],'ncm');
save(['.',path,'\wm.mat'],'wm');
save(['.',path,'\Q.mat'],'Q');

%%