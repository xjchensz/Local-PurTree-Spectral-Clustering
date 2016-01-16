function [  ] = draw_Dist( y, distX )
%DRAW Summary of this function goes here
%   Detailed explanation goes here
%P

%draw distX
figure('name','Orignal distances'); 
imshow(distX,[]); colorbar;
figure('name','Arranged distances learned by LPT'); 
[~, idx]=sort(y,1);
imshow(distX(idx,idx),[]); colorbar;

end

