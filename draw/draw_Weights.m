function [  ] = draw_Weights( W )
%DRAW Summary of this function goes here
%   Detailed explanation goes here
%P

%draw W
figure('name','Learned weights'); 
plot(W,'b-*')
legend('Weight','Levels','NE')
xlabel('\omega')
ylabel('Weight')

end