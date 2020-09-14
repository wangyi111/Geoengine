%% dse lab6 task2
% author: Yi Wang
% last change: 08/07/2019
clear;
clc;
data=load('KF_task2.txt');
t=data(:,1);
x1=data(:,2);
n=length(x1);
%x1=[x1';zeros(1,n)];
x=[-1;0];
m=20;
k=7;
b=2;
R=0.09;
%R=9;


F=[0,1;-k/m,-b/m];
P=[0.1,0;0,0.1];
dt=0.25;
H=[1,0];
Q=0.0004*[dt,0;0,dt];
%Q=0.04*[dt,0;0,dt];
for i=1:n
    Phi=expm(F*dt);
    
    x=Phi*x;
    P=Phi*P*Phi'+Q;
    K=P*H'*(H*P*H'+R)^(-1);
    I=eye(2,2);
    x=x+K*(x1(i)-H*x);
    P=(I-K*H)*P;
    x_k(i)=x(1);
    v_k(i)=x(2);
    P_k(i)=P(1,1);
end


rhs=@(t,xx) F*xx;
[~,trueTrajectory]=ode45(rhs,t,[1,0]);

figure(1);
plot(t,x_k);hold on;

plot(t,trueTrajectory(:,1));
legend('x_k','x_t');
title('position');
figure(2);
plot(t,P_k);
title('variance');
figure(3);
plot(t,x1);
title('measurement');

