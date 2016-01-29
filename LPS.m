function [y, P, W, distX, evs] = LPS(D, c, k, islocal, eta)

% D: num*num*level distance matrix, each sub matrix ia the level distance matrix
% c: number of clusters
% k: number of neighbors to determine the initial graph, and the parameter r if r<=0
% eta: regularization coefficient
%
% islocal:
%           1: only update the similarities of the k neighbor pairs, faster
%           0: update all the similarities
% y: num*1 cluster indicator vector
% P: num*num learned symmetric similarity matrix
% evs: eigenvalues of learned graph Laplacian in the iterations
% W:weights
%
%
%%

NITER = 50;
level=size(D,3); %levels
num = size(D,2);%no. of objects

if nargin<3 || k<=0
    k=20;
end;

if k>num-2
    k=num-2;
end;

if nargin<4
    islocal=1;
end;



P = zeros(num,num);
W = zeros(level,1);%weights
W(:) = 1/level;
rr = zeros(num,1);
distX=computeWeightDistance(W,D);
b=zeros(level,2);

if islocal
    DA = sort(D,2);
    [~, idx] = sort(distX,2);
    if nargin<5
        eta=0;
        nn=0;
    end
    for i = 1:num
        id=idx(i,2:k+1);
        di = distX(id);
        ddk_1=k*DA(i,k+2,:)-sum(DA(i,2:k+1,:),2);
        ddk=k*DA(i,k+1,:)-sum(DA(i,2:k+1,:),2);
        rr(i) = 0.5*(max(ddk)+min(ddk_1));
        
        if nargin<5
            for l=1:level
                for h=1:level
                    F=DA(i,2:k+1,h)-DA(i,2:k+1,l);
                    b(l,1)=b(l,1)+min(F,[],2);
                    b(l,2)=b(l,2)+max(F,[],2);
                end
            end
            
            eek=0.5*sum(reshape(sum(ddk,2),[level,1]).*b(:,2))/(2*level*rr(i)-sum(sum(ddk,3),2));
            eek1=0.5*sum(reshape(sum(ddk_1,2),[level,1]).*b(:,1))/(2*level*rr(i)-sum(sum(ddk_1,3),2));
            if eek>0 && eek1>0
                eta=eta+0.5*(eek+eek1);
                nn=nn+1;
            end
        end;
        
        P(i,id)=distX(idx(i,k+2))-di;
        y=sum(P(i,:));
        if y==0
            P(i,id)=1/k;
        else
            P(i,id)= P(i,id)/y;
        end
    end
    
    if nargin<5
        if nn<=0
            eta=sum(DA(i,2:k+1,:));
        else
            eta=eta/nn;
        end
    end
else
    if nargin<5
        eta=0;
        nn=0;
    end
    
    for i = 1:num
        di = distX(i,:);
        
        dd=size(D,1)*max(D(i,:,:),[],2)-sum(D(i,:,:),2);
        rr(i) = mean(dd);
        
        if nargin<5
            for l=1:level
                for h=1:level
                    F=D(i,:,h)-D(i,:,l);
                    b(l,1)=b(l,1)+min(F,[],2);
                    b(l,2)=b(l,2)+max(F,[],2);
                end
            end
            
            
            eek=0.5*sum(reshape(sum(dd,2),[level,1]).*b(:,2))/(2*level*rr(i)-sum(sum(dd,3),2));
            if eek>0
                eta=eta+eek;
                nn=nn+1;
            end
        end;
        
        P(i,:)=distX(i,:)-di;
        y=sum(P(i,:))-di(i);
        if y==0
            P(i,:)=1/num;
        else
            P(i,:)= P(i,:)/y;
        end
        P(i,i)=0;
    end
    
    if nargin<5
        if nn<=0
            eta=sum(D(i,:,:));
        else
            eta=eta/nn;
        end
    end
end

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
    W(:) = 0;
    if islocal
        for l=1:level
            for i=1:num
                W(l,1)= W(l,1)+sum(D(i,idx(i,:),l).*P(i,idx(i,:)));
            end
        end
    else
        for l=1:level
            for i=1:num
                W(l,1)= W(l,1)+sum(D(i,:,l).*P(i,:));
            end
        end
    end
    W=mean(W)-W;
    W=1/level+W/(2*eta);
    W=positiveNorm(W);
    
    %update distance
    distX=computeWeightDistance(W,D);%full dist--weight distanceï¼?
    [~, idx] = sort(distX,2);
    if islocal
        idx=idx(:,2:k+1);
    end
    
    
    % compute P
    distf = L2_distance_1(F',F');
    
    P(:,:)=0;
    for i=1:num
        if islocal == 1
            id=idx(i,:);
            E=(distX(i,id)+lambda*distf(i,id))/(2*r);
            E = mean(E)-E + 1/k;
            P(i,id) = positiveNorm(E);
        else
            E=(distX(i,:)+lambda*distf(i,:))/(2*r);
            E(i)=0;
            E = mean(E)-E + 1/num;
            E(i)=0;
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
    if fn1 > 1e-11
        % more clusters than expected
        lambda = 1.2*lambda;
    elseif fn2 < 1e-11
        lambda = lambda/1.2;
        F = F_old;
    else
        break;
    end;
end;



%[labv, tem, y] = unique(round(0.1*round(1000*F)),'rows');
[clusternum, y]=graphconncomp(sparse(P));
y = y';
if clusternum ~= c
    sprintf('The final cluster number is: %d. Can not find the correct cluster number: %d',clusternum, c)
else
    sprintf('Succeed in uncovering %d clusters', c)
end;
