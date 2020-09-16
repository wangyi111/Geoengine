clear;
clc;
%% Task2
% a
f_L1=1575.42e6;
f_L2=1227.60e6;
f_L5=1176.45e6;
TEC_L1=132e16;
dL1=40.3/f_L1^2*TEC_L1;
disp(dL1);
TEC_L2=dL1*f_L2^2/40.3*1e-16;
disp(TEC_L2);
% b
s_L1_1=0.3;
s_L2=0.25;
s_L3_1_2=sqrt((f_L1^2/(f_L1^2-f_L2^2))^2*s_L1_1^2+(f_L2^2/(f_L1^2-f_L2^2))^2*s_L2^2);
disp(s_L3_1_2);
s_L1_2=0.25;
s_L5=0.2;
s_L3_1_5=sqrt((f_L1^2/(f_L1^2-f_L5^2))^2*s_L1_2^2+(f_L5^2/(f_L1^2-f_L5^2))^2*s_L5^2);
disp(s_L3_1_5);


%% Task 3
% receiver position    
% phi=0;
% lambda=0;
% h=0;
% wgs84 ellipsoid
% a=6378137;
% f=1/298.25722;
% e2=2*f-f^2;
% N=a/(sqrt(1-e2*(sin(phi))^2));
% 
% x=(N+h)*cos(phi)*cos(lambda);
% y=(N+h)*cos(phi)*sin(lambda);
% z=((1-e2)*N+h)*sin(phi);      % ecef? or inertial?
x=0;
y=0;
z=0;


% satellite position
% a
H=25000000;

El{1}=[60*pi/180*ones(4,1);90*pi/180];
Az{1}=[0;90*pi/180;180*pi/180;270*pi/180;0];
% b
El{2}=[45*pi/180*ones(4,1);90*pi/180];
Az{2}=[0;90*pi/180;180*pi/180;270*pi/180;0];
% c
El{3}=[30*pi/180*ones(4,1);90*pi/180];
Az{3}=[0;90*pi/180;180*pi/180;270*pi/180;0];
% d
El{4}=[0*pi/180*ones(4,1);90*pi/180];
Az{4}=[0;90*pi/180;180*pi/180;270*pi/180;0];
% e
El{5}=[0*pi/180*ones(4,1);90*pi/180];
Az{5}=[45*pi/180;135*pi/180;225*pi/180;315*pi/180;0];

for i=1:5
[X,Y,Z]=st2ecef(El{i},Az{i},H);

p=sqrt((X-x).^2+(Y-y).^2+(Z-z).^2);
% c=299792458;
c=3;
% dt=p/c;
A=[(x-X)./p,(y-Y)./p,(z-Z)./p,ones(5,1)*c];
Q=(A'*A)^(-1);
sigma=10;
% DOP: G P H V T
DOP(i,1)=sigma*sqrt(trace(Q));
DOP(i,2)=sigma*sqrt(Q(1,1)+Q(2,2)+Q(3,3));
DOP(i,3)=sigma*sqrt(Q(1,1)+Q(2,2)); % transform to local coordinates?
DOP(i,4)=sigma*sqrt(Q(3,3));
DOP(i,5)=sigma*sqrt(Q(4,4));

cor(i)=Q(3,4)/sqrt(Q(3,3)*Q(4,4));



% plot(cor);
end
plot(cor);

function [X,Y,Z]=st2ecef(E,A,H)
% R_E=6378137;
% alfa=asin(R_E*sin(pi-E)./H);
% h=R_E*sin(pi-pi+E-alfa)./sin(alfa);
h=H;
X=h.*cos(E).*cos(A);
Y=h.*cos(E).*sin(A);
Z=h.*sin(E);
end
