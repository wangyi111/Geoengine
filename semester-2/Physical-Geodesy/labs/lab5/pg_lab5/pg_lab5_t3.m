close all;
clear;
clc;
theta=linspace(0,180,181);
l=12;
temp_p=0;
for m=0:l
temp_p=temp_p+(RC_P(l,m,theta/180*pi)).^2;
end
P=temp_p/(2*l+1);

figure(1);
plot(theta,P);