function [ v ] = expNorm( v )
%EXPNORM Summary of this function goes here
%   Detailed explanation goes here
% compute v=e(v)/\sum e(v)

vmax= max(v);
v=exp(v-vmax);
v=v/sum(v);
end

