clear;
clc;

G=6.672e-11;
rho=5515;
R=6371000;
w=7.292115e-5;


lambda=10/180*pi;
%i=linspace(0,90);
%i=i/180*pi;
phi=42/180*pi;
task=1;

%% T1
if task==1
for i=0:90
    phi=i/180*pi;
V=4/3*pi*G*rho*R^2;
Vc(i+1)=1/2*w^2*R^2*(cos(phi))^2;
W=V+Vc;
%r_=zeros(3,1);
r_(1)=R*cos(phi)*cos(lambda);
r_(2)=R*cos(phi)*sin(lambda);
r_(3)=R*sin(phi);
%r_=(R*cos(i)*cos(lambda);R*cos(i)*sin(lambda);R*sin(i));
a_=-G*4/3*pi*rho*r_;
a=norm(a_);
ac_(1)=w^2*r_(1);
ac_(2)=w^2*r_(2);
ac_(3)=0;
g_=a_+ac_;
g=norm(g_);
ksi(i+1)=acos(dot(a_,g_)/(a*g))/pi*180;
dg(i+1)=g-a;

end

set(0,'defaultfigurecolor','w')
t=0:1:90;
figure(1);
plot(t,ksi);
title('Disturbance of the direction \xi');
xlabel('\phi (\circ)');
ylabel('\xi (\circ)');
figure(2);
plot(t,dg);
title('Disturbance of the attraction \deltag');
xlabel('\phi (\circ)');
ylabel('\deltag (m/s^2)');
figure(3);
plot(t,Vc);
title('Centrifugal potential Vc');
xlabel('\phi (\circ)');
ylabel('Vc (m^2/s^2)');

end

%% T2
if task==2
    v=400/3.6;
    ace1_(1)=2*w*(-sin(lambda)*v);
    ace1_(2)=2*w*(cos(lambda)*v);
    ace1_(3)=0;
    ace1=norm(ace1_);
    
    ace2_(1)=2*w*(-sin(phi)*cos(lambda)*v);
    ace2_(2)=2*w*(-sin(phi)*sin(lambda)*v);
    ace2_(3)=2*w*cos(phi)*v;
    ace2=norm(ace2_);
    
    act1_(1)=2*w*(-sin(phi)*v);
    act1_(2)=2*w*0;
    act1_(3)=2*w*(cos(phi)*v);
    act1=norm(act1_);
    sigma_v1=1e-5/(2*w);
    
    
    act2_(1)=2*w*0;
    act2_(2)=2*w*sin(phi)*v;
    act2_(3)=2*w*0;
    act2=norm(act2_);
    sigma_v2=1e-5/(2*w*sin(phi));
    
end