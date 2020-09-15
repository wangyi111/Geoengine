close all;
clear;
clc;
% initialization
for i=1:101
    Left{i}=zeros(1,91);
    Right{i}=zeros(1,91);
end

for l=0:100
% left hand side
theta_Q=linspace(0,90,91);
t=sin(0)*sin(90-theta_Q)+cos(0)*cos(90-theta_Q)*cos(0);
syms f1(x)
f1(x)=1/(2^l*factorial(l))*diff((x^2-1)^l,l);
Left{l+1}=double(f1(t));

% right hand side
right=0;
for m=0:l
right=right+1/(2*l+1)*RF_P(l,m,0)*RF_P(l,m,cos(theta_Q/180*pi));
end
Right{l+1}=right;
end

figure(1);
subplot(1,2,1);
for l=0:100
plot(theta_Q,Left{l+1});
hold on;
end
title('left');
subplot(1,2,2);
for l=0:100
plot(theta_Q,right{l+1});
hold on;
end
title('right');

figure(2);
for l=0:100
plot(theta_Q,right{l+1}-Left{l+1});
hold on;
end
title('difference between left and right hand side');


