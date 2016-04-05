%transform mat-->csv
%
%%
path='.';
% m = load('ncm_NCut.mat');
% dlmwrite('ncm_NCut.csv', ncm_NCut);
m = load('ncm_NCut.mat');
dlmwrite('Nncm.csv','m');
%%