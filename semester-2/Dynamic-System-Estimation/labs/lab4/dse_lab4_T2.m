%% Dynamic System Estimation Lab4: Kalman Filter
% author: Yi Wang
% last change: 17/06/2019

clear;
clc;

% load data
data=load('exampleKF2.txt');
X_ob=data(:,1);
Y_ob=data(:,2);
Z_ob=data(:,3);
n=length(X_ob);
% initializaiton
x=[-12823317;-11933101;20070042;2000;-1000;1000];
Sigma=[10,0,0,0,0,0;0,10,0,0,0,0;0,0,10,0,0,0;0,0,0,100,0,0;0,0,0,0,100,0;0,0,0,0,0,100];
u=0;
w=1;
dt=1;
P=Sigma;
% observation equation Z=H*X+e
H=[1,0,0,0,0,0;0,1,0,0,0,0;0,0,1,0,0,0];
R=2500*[1,0,0;0,1,0;0,0,1];

%% forward kalman filter
for i=1:n
tx=x(1);ty=x(2);tz=x(3);
a=-3.986005e14/(tx^2+ty^2+tz^2)^(3/2);
F=[0,0,0,1,0,0;0,0,0,0,1,0;0,0,0,0,0,1;a,0,0,0,0,0;0,a,0,0,0,0;0,0,a,0,0,0];
G=30*[0;0;0;1;1;1];
%Phi=expm(F*dt);

A=[-F,G*w*G';zeros(6,6),F']*dt;
B=expm(A);
Phi=B(7:12,7:12)';
Q=Phi*B(1:6,7:12);

% prediction
x=Phi*x+u;
P=Phi*P*Phi'+Q;
% kalman gain
K=P*H'*(H*P*H'+R)^(-1);
% update
I=[1,0,0,0,0,0;0,1,0,0,0,0;0,0,1,0,0,0;0,0,0,1,0,0;0,0,0,0,1,0;0,0,0,0,0,1];
P=(I-K*H)*P;
P_for{i}=P;
x=x+K*(data(i,:)'-H*x);
x_forward=x+K*(data(i,:)'-H*x);

x_for{i}=x_forward;
X_forward(i)=x_forward(1);
Y_forward(i)=x_forward(2);
Z_forward(i)=x_forward(3);
VX_forward(i)=x_forward(4);
VY_forward(i)=x_forward(5);
VZ_forward(i)=x_forward(6);


    PX_forward(i)=P(1,1);
    PY_forward(i)=P(2,2);
    PZ_forward(i)=P(3,3);

end

%% backward kalman filter
P=Sigma;
%dt=-1;
for i=1:n
tx=x(1);ty=x(2);tz=x(3);
a=-3.986005e14/(tx^2+ty^2+tz^2)^(3/2);
F=[0,0,0,1,0,0;0,0,0,0,1,0;0,0,0,0,0,1;a,0,0,0,0,0;0,a,0,0,0,0;0,0,a,0,0,0];
G=30*[0;0;0;1;1;1];
%Phi=expm(F*dt);

A=[-F,G*w*G';zeros(6,6),F']*dt;
B=expm(A);
Phi=B(7:12,7:12)';
Q=Phi*B(1:6,7:12);

% prediction
x=Phi*x+u;
P=Phi*P*Phi'+Q;
% kalman gain
K=P*H'*(H*P*H'+R)^(-1);
% update
I=[1,0,0,0,0,0;0,1,0,0,0,0;0,0,1,0,0,0;0,0,0,1,0,0;0,0,0,0,1,0;0,0,0,0,0,1];
P=(I-K*H)*P;
P_back{i}=P;
x=x+K*(data(n-i+1,:)'-H*x);
x_backward=x+K*(data(n-i+1,:)'-H*x);
x_back{n-i+1}=x_backward;
X_backward(n-i+1)=x_backward(1);
Y_backward(n-i+1)=x_backward(2);
Z_backward(n-i+1)=x_backward(3);
VX_backward(n-i+1)=x_backward(4);
VY_backward(n-i+1)=x_backward(5);
VZ_backward(n-i+1)=x_backward(6);

    PX_backward(n-i+1)=P(1,1);
    PY_backward(n-i+1)=P(2,2);
    PZ_backward(n-i+1)=P(3,3);



end

%% smoothed kalman filter
for i=1:n
%     AA=P_back{i}*(P_for{i}+P_back{i})^(-1);
%     x_smooth=AA*x_for{i}+(I-AA)*x_back{i};
%     P_smooth=AA*P_for{i}*AA'+(I-AA)*P_back{i}*(I-AA)';
P_smooth=((P_back{i})^(-1)+(P_for{i})^(-1))^(-1);    
x_smooth=P_smooth*((P_for{i})^(-1)*x_for{i}+(P_back{i})^(-1)*x_back{i});
    
    
    X_smooth(i)=x_smooth(1);
    Y_smooth(i)=x_smooth(2);
    Z_smooth(i)=x_smooth(3);
    VX_smooth(i)=x_smooth(4);
    VY_smooth(i)=x_smooth(5);
    VZ_smooth(i)=x_smooth(6);    
    
    
    PX_smooth(i)=P_smooth(1);
    PY_smooth(i)=P_smooth(2);
    PZ_smooth(i)=P_smooth(3);
end

%% plot result
t=1:n;
figure(1);
subplot(3,2,1);
plot(t,X_forward);hold on;
plot(t,X_backward);hold on;
plot(t,X_smooth);

subplot(3,2,2);
plot(t,VX_forward);hold on;
plot(t,VX_backward);hold on;
plot(t,VX_smooth);

subplot(3,2,3);
plot(t,Y_forward);hold on;
plot(t,Y_backward);hold on;
plot(t,Y_smooth);

subplot(3,2,4);
plot(t,VY_forward);hold on;
plot(t,VY_backward);hold on;
plot(t,VY_smooth);

subplot(3,2,5);
plot(t,Z_forward);hold on;
plot(t,Z_backward);hold on;
plot(t,Z_smooth);

subplot(3,2,6);
plot(t,VZ_forward);hold on;
plot(t,VZ_backward);hold on;
plot(t,VZ_smooth);



figure(2);
subplot(3,1,1);
plot(t,sqrt(PX_forward),'r'); hold on;
plot(t,sqrt(PX_backward),'g'); hold on;
plot(t,sqrt(PX_smooth),'b'); hold on;

subplot(3,1,2);
plot(t,sqrt(PY_forward),'r'); hold on;
plot(t,sqrt(PY_backward),'g'); hold on;
plot(t,sqrt(PY_smooth),'b'); hold on;

subplot(3,1,3);
plot(t,sqrt(PZ_forward),'r'); hold on;
plot(t,sqrt(PZ_backward),'g'); hold on;
plot(t,sqrt(PZ_smooth),'b'); hold on;

figure;
plot3(X_ob,Y_ob,Z_ob,'k'); hold on;
plot3(X_forward,Y_forward,Z_forward,'r'); hold on;
plot3(X_backward,Y_backward,Z_backward,'g'); hold on;
plot3(X_smooth,Y_smooth,Z_smooth,'b'); 
view([0 90])
legend('observation','forward','backward','smooth');
title('trajectories of the satellite');
xlabel('X');
ylabel('Y');
zlabel('Z');
% 
% t=1:n;
% figure(2);
% plot(t,PX_forward,'r'); hold on;
% plot(t,PY_forward,'g'); hold on;
% plot(t,PZ_forward,'b'); hold on;
% title('covariance of X,Y,Z');
% legend('X','Y','Z');
% xlabel('time (s)');
% ylabel('covariance');