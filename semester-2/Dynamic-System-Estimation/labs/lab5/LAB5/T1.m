%% Dynamic System Estimation Lab5_T1


clear;
clc;

h=21.86;
sigp=2;
sigm=0.1;
t=[0;3.2;7.5;12.1;17.8];
z=[36.25;55.06;76.66;104.42];
xn=[13;zeros(4,1)];
pn=[1;zeros(4,1)];

for i=1:4
   Phi=1;
   dt=t(i+1)-t(i);
   Q=sigp*sigp*dt;
   xn(i+1)=Phi*xn(i);
   pn(i+1)=Phi*pn(i)*Phi'+Q;
   hn=xn(i+1)/((477.8596+xn(i+1)*xn(i+1))^(0.5));
   kn=pn(i+1)*hn'*inv((hn*pn(i+1)*hn'+0.01));
   pn(i+1)=(1-kn*hn)*pn(i+1);
   xn(i+1)=xn(i+1)+kn*(z(i)-sqrt(xn(i+1)*xn(i+1)+h*h));
end

plot(t,xn);
figure
plot(t,pn);
% legend('x','variance');

