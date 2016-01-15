%%
function [ W ] = normal_LPT( W )
%NORMAL_LPT Summary of this function goes here
%   Detailed explanation goes here

y=sum(W,2); 
for i=1:size(W,1);
  if y(i,1)==0
    W(i,:)=1/size(W,2);
  else
    W(i,:)=W(i,:)/(y(i,1)+eps);
  end
end

end
%%
