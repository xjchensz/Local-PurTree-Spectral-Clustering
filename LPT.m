function [y, A, evs] = LPT(D, c, k, islocal)

% D: level*num*num distance matrix, each sub matrix ia the level distance matrix
% c: number of clusters
% k: number of neighbors to determine the initial graph, and the parameter r if r<=0
% 
% islocal:
%           1: only update the similarities of the k neighbor pairs, faster
%           0: update all the similarities
% y: num*1 cluster indicator vector
% A: num*num learned symmetric similarity matrix
% evs: eigenvalues of learned graph Laplacian in the iterations
%
% H:levels
% 
%%


NITER = 30;
H=size(D,1); %levels
num = size(D,2);%no. of objects 

if k<=0
    k=15;
end;

[dist, idx] = sort(D,1);%dist--distance
P = zeros(num);
W = zeros(H,1);%weights
W(:) = 1/H;
rr = zeros(num,1);                                                                                   m,1);
lamda=0;
E = sum(W*sum(dist))+lamda*dfi;

for i = 1:num
    di = dist(i,2:k+2);
    rr(i) = 0.5*(k*di(k+1)-sum(di(1:k)));
    id = idx(i,2:k+2);
    P(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
    
    
    r(i) = k/(num*H)*W(i)*sum(rr);
    
    P(i,id) = 1/k + (sum(E)-k*E)/(2*k*r);
    
end;

if r <= 0
    r = mean(rr);
end;
lambda = mean(rr);

P0 = (P+P')/2;
D0 = diag(sum(P0));
L0 = D0 - P0;
[F, temp, evs]=eig1(L0, c, 0);

if sum(evs(1:c+1)) < 0.00000000001
    error('The original graph has more than %d connected component', c);
end;

for iter = 1:NITER
    distf = L2_distance_1(F',F');
    A = zeros(num);
    for i=1:num
        if islocal == 1
            idxa0 = idx(i,2:k+1);
        else
            idxa0 = 1:num;
        end;
        dfi = distf(i,idxa0);
        dxi = distX(i,idxa0);
        ad = -(dxi+lambda*dfi)/(2*r);
        A(i,idxa0) = EProjSimplex_new(ad);
    end;
    
    A = (A+A')/2;
    D = diag(sum(A));
    L = D-A;
    F_old = F;
    [F, temp, ev]=eig1(L, c, 0);
    evs(:,iter+1) = ev;
    
    fn1 = sum(ev(1:c));
    fn2 = sum(ev(1:c+1));
    if fn1 > 0.00000000001
        lambda = 2*lambda;
    elseif fn2 < 0.00000000001
        lambda = lambda/2;  F = F_old;
    else
        break;
    end;
    
end;

%[labv, tem, y] = unique(round(0.1*round(1000*F)),'rows');
[clusternum, y]=graphconncomp(sparse(A)); y = y';
if clusternum ~= c
    sprintf('Can not find the correct cluster number: %d', c)
end;




%%