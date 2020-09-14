%% DSE_Lab5_T2
%

clc
clear all
m=load('EFK_task2.txt');
dt=0.0025;
d1=m(:,2);
d2=m(:,3);
zn=[d1 d2]';
G=[0 0 1 1]';
F=[0 0 1 0;0 0 0 1;0 0 0 0;0 0 0 0];
x1=-3.5;
y1=-3.5;
x2=3.5;
y2=-3.5;
W=4;
A=[-F G*W*G';zeros(4,4) F']*dt;
B=expm(A);
phi=B(5:8,5:8)';
% Q=phi*B(1:4,5:8);
Q =4*[dt*dt*dt/3 0 dt*dt/2 0;0 dt*dt*dt/3 0 dt*dt/2;dt*dt/2 0 dt 0;0 dt*dt/2 0 dt];
x0=[0 2 0 0]';
xn=[x0 zeros(4,401)];
pn=[10*eye(4,4) zeros(4,401)];

for i=1:401
    xn(:,i+1)=phi*xn(:,i);
    pn(:,4*i+1:4*i+4)=phi*pn(:,4*i-3:4*i)*phi'+Q;
    h1x=(xn(1,i+1)-x1).*(((xn(1,i+1)-x1).^2+(xn(2,i+1)-y1).^2).^(-0.5));
    h1y=(xn(2,i+1)-y1).*(((xn(1,i+1)-x1).^2+(xn(2,i+1)-y1).^2).^(-0.5));
    h2x=(xn(1,i+1)-x2).*(((xn(1,i+1)-x2).^2+(xn(2,i+1)-y2).^2).^(-0.5));
    h2y=(xn(2,i+1)-y2).*(((xn(1,i+1)-x2).^2+(xn(2,i+1)-y2).^2).^(-0.5));
    hn=[h1x h1y 0 0;h2x h2y 0 0];
    kn=pn(:,4*i+1:4*i+4)*hn'*inv((hn*pn(:,4*i+1:4*i+4)*hn'+0.01^2*eye(2,2)));
    xn(:,i+1)=xn(:,i+1)+kn*(zn(:,i)-[(((xn(1,i+1)-x1).^2+(xn(2,i+1)-y1).^2).^(0.5));(((xn(1,i+1)-x2).^2+(xn(2,i+1)-y2).^2).^(0.5))]);
    pn(:,4*i+1:4*i+4)=(eye(4,4)-kn*hn)*pn(:,4*i+1:4*i+4);
    
end
t=0:0.0025:1;
figure
%subplot(1,2,1);
plot(xn(1,:),xn(2,:)); hold on;
% title('positon of prediction')
% subplot(1,2,2);
r=2+sin(20*pi.*t);
x=r.*sin(2*pi.*t);
y=r.*cos(2*pi.*t);
plot(x,y);
title('positon of prediciton & true')
legend('prediction','true');
figure
% plot(xn(3,:));hold on

vx=20*pi.*cos(20*pi.*t).*sin(2*pi.*t)+(2+sin(20*pi.*t)).*2*pi.*cos(2*pi.*t);
plot(t,vx,'-.',t,xn(3,2:402));hold on
legend('true','prediction');
title('comparision of  velocitie vx between true and prediction ')
% plot(t,xn(3,2:402));
figure;
vy=20*pi.*cos(20*pi.*t).*cos(2*pi.*t)-(2+sin(20*pi.*t)).*2*pi.*sin(2*pi.*t);
plot(t,vy,'-.',t,xn(4,2:402));hold on
% plot(t,xn(4,2:402));
legend('true','prediction');
title('comparision of  velocitie vy between true and prediction ')
sigmax=pn(1,1:4:1605);
sigmay=pn(2,2:4:1606);
sigmavx=pn(3,3:4:1607);
sigmavy=pn(4,4:4:1608);
figure;
plot(t,sigmax(2:402),'r',t,sigmay(2:402),'g');hold on
legend('sigmax','sigmay');
title('comparision for deviation of positions')
figure;
plot(t,sigmavx(2:402),'r',t,sigmavy(2:402),'g');hold on
legend('sigmavx','sigmavy');
title('comparision for the deviation of vilocities')