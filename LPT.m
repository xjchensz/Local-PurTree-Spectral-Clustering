function [y, P, W, evs] = LPT(D, c, k, islocal, eta)

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
level=size(D,3); %levels
num = size(D,2);%no. of objects

if nargin<3 || k<=0
    k=15;
end;

if k>num-2
    k=num-2;
end;

if nargin<4
    islocal=1;
end;

if nargin<5
    eta=1;
end;

[~, idx] = sort(D(:,:,1),2);
idx=idx(:,2:k+2);
Z=zeros(num,k+1,level);
for i = 1:num
    Z(i,:,:)=D(i,idx(i,:),:);
end


P = zeros(num,num);
W = zeros(level,1);%weights
W(:) = 1/level;
rr = zeros(num,1);
dist=computeWeightDistance(W,Z);%local dist--weight distance
distK_1=dist(:,k+1);
idx=idx(:,1:k);
dist=dist(:,1:k);
Z=Z(:,1:k,:);
if islocal==0
    distX=computeWeightDistance(W,D);%full dist--weight distance
end

for i = 1:num
    id=idx(i,:);
    di = dist(i,:);
    rr(i) = 0.5*(k*distK_1(i,1)-sum(di));
    P(i,id)=distK_1(i,1)-di;
    y=sum(P(i,:));
    if y==0
       P(i,id)=1/k;
    else
       P(i,id)= P(i,id)/y;
    end
end;

r = mean(rr);
lambda = mean(rr);

P0 = (P+P')/2;
D0 = diag(sum(P0));
L0 = D0 - P0;
[F, ~, evs]=eig1(L0, c, 0);

% if sum(evs(1:c+1)) < 0.00000000001
%     error('The original graph has more than %d connected component', c);
% end;

for iter = 1:NITER
    

    % compute weights
    W=zeros(level,1);
    for l=1:level
        for i=1:num
            W(l,1)= W(l,1)+sum(Z(i,:,l).*P(i,idx(i,:)));
        end
    end
    W=expNorm(-W/eta);
   
    %update distance
    
    if islocal
        dist=computeWeightDistance(W,Z);%local dist--weight distance
    else
        distX=computeWeightDistance(W,D);%full dist--weight distance
    end

    % compute P
    distf = L2_distance_1(F',F');
    
    for i=1:num
        if islocal == 1
            id=idx(i,:);
            dfi = distf(i,id);
            E=(dist(i,:)+lambda*dfi)/(2*r);
            E = mean(E)-E + 1/k;
            P(i,id) = positiveNorm(E);
        else
            E=-(distX(i,:)+lambda*distf(i,:))/(2*r);
            E = mean(E)-E + 1/num;
            P(i,:) = positiveNorm(E);
        end;
    end;
    
    % compute F
    P0 = (P+P')/2;
    D0 = diag(sum(P0));
    L0 = D0 - P0;
    F_old = F;
    [F, ~, ev]=eig1(L0, c, 0);
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
[clusternum, y]=graphconncomp(sparse(P)); y = y';
if clusternum ~= c
    sprintf('The final cluster number is: %d. Can not find the correct cluster number: %d',clusternum, c)
end;




%%