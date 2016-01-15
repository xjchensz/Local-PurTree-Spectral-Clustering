function [x iter] = positiveNorm(v)

%
%% Problem
%
%  x>=0, 1'v=1
%

iter=1;
 
%vmax = max(v0);
vmin = min(v);
if vmin < 0
    f = 1;
    lambda_m = 0;
    while abs(f) > 10^-10
        v1 = v - lambda_m;
        posidx = v1>0;
        npos = sum(posidx);
        g = -npos;
        f = sum(v1(posidx)) - 1;
        lambda_m = lambda_m - f/g;
        iter=iter+1;
        if iter > 100
            x = max(v1,0);
            break;
        end;
    end;
    x = max(v1,0);

else
    x = v;
end;