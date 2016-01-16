function [  ] = draw_P( y, P )
%DRAW Summary of this function goes here
%   Detailed explanation goes here
%P

%draw distX
figure('name','Arranged probabilities learned by LPT'); 
[~, idx]=sort(y,1);
imshow(P(idx,idx),[]); colormap jet; colorbar;

end

