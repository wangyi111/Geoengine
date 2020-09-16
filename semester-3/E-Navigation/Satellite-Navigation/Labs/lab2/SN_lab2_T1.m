clear;
clc;
format longg;
%GM=3.9860044188e14;
%% T1.1
a=26371000;
e=0.4;
I=dms2rad(45);
Omega=dms2rad(50);
omega=dms2rad(110);
T0=0;
t=24*60*60;
dt=10;
[r1,v1,ro1,vo1]=kep2cart(a,e,I,Omega,omega,T0,t,dt);

figure(6);
subplot(1,2,1);
plot3(r1(1,:),r1(2,:),r1(3,:));
title('orbit plane coordinates 3d');
subplot(1,2,2);
V1=sqrt(v1(1,:).^2+v1(2,:).^2+v1(3,:).^2);
scatter3(r1(1,:),r1(2,:),r1(3,:),10,V1);


figure(1);
subplot(1,2,1);
plot(ro1(1,:),ro1(2,:),'o');
title('orbit plane coordinates');
subplot(1,2,2);
V1=sqrt(vo1(1,:).^2+vo1(2,:).^2+vo1(3,:).^2);
scatter(ro1(1,:),ro1(2,:),10,V1);


%% T1.2
[a1_2,e1_2,I1_2,Omega1_2,omega1_2]=cart2kep(r1,v1);
%plot(omega1_2);
%% T1.3
r1_3=orb2ECEF(r1);
figure(2);
plot3(r1_3(1,:),r1_3(2,:),r1_3(3,:));
title('ECEF');

%% T1.4
% 1 Galileo 2 Glonass 3 GPS
[SV1,PRN1,a1,e1,I1,Omega1,omega1,M1]=textread("Galileo.txt",'%d %d %f %f %f %f %f %f','headerlines',1);
[SV2,a2,e2,I2,Omega2,omega2,M2]=textread("GLONASS.txt",'%d %f %f %f %f %f %f','headerlines',1);
[SV3,a3,e3,I3,Omega3,omega3,M3]=textread("GPS.txt",'%s %f %f %f %f %f %f','headerlines',1);
a1=a1*1000;
a2=a2*1000;
a3=a3*1000;

I1=dms2rad(I1);
I2=dms2rad(I2);
I3=dms2rad(I3);

Omega1=dms2rad(Omega1);
Omega2=dms2rad(Omega2);
Omega3=dms2rad(Omega3);

omega1=dms2rad(omega1);
omega2=dms2rad(omega2);
omega3=dms2rad(omega3);

M1=dms2rad(M1);
M2=dms2rad(M2);
M3=dms2rad(M3);

r_1=zeros(100,2881);
r_2=zeros(100,2881);
r_3=zeros(100,2881);
figure(3);
for i=1:length(SV1)
    
[r_1((i*3-2):(3*i),:),v_1((i*3-2):(3*i),:),ro_1((i*3-2):(3*i),:),vo_1((i*3-2):(3*i),:)]=kep2cart(a1(i),e1(i),I1(i),Omega1(i),omega1(i),0,t,30);

plot3(r_1(3*i-2,:),r_1(3*i-1,:),r_1(3*i,:));
hold on;

end
title('Galileo');



figure(4);
for i=1:length(SV2)
    [r_2((i*3-2):(3*i),:),v_2((i*3-2):(3*i),:),ro_2((i*3-2):(3*i),:),vo_2((i*3-2):(3*i),:)]=kep2cart(a2(i),e2(i),I2(i),Omega2(i),omega2(i),0,t,30);
    plot3(r_2(3*i-2,:),r_2(3*i-1,:),r_2(3*i,:));
    hold on;
end
title('GLONASS');

figure(5);
for i=1:length(SV3)
    
    [r_3((i*3-2):(3*i),:),v_3((i*3-2):(3*i),:),ro_3((i*3-2):(3*i),:),vo_3((i*3-2):(3*i),:)]=kep2cart(a3(i),e3(i),I3(i),Omega3(i),omega3(i),0,t,30);
    plot3(r_3(3*i-2,:),r_3(3*i-1,:),r_3(3*i,:));
hold on;
end
title('GPS');






%%

function y=dms2rad(x)
y=x/180*pi;
end

function y=R1(x)
y=[1,0,0;0,cos(x),sin(x);0,-sin(x),cos(x)];
end
function y=R2(x)
y=[cos(x),0,-sin(x);0,1,0;sin(x),0,cos(x)];
end
function y=R3(x)
y=[cos(x),sin(x),0;-sin(x),cos(x),0;0,0,1];
end

function [r,v,ro,vo]=kep2cart(a,e,I,Omega,omega,T0,t,dt)
GM=3.9860044e14;
%T=24*60*60;
%t0=0;
%t=0:10:T;
%n=2*pi/t;
tt=0:dt:t;
n=sqrt(GM/(a^3));
%M=0;
E=zeros(1,length(tt));
%for i=0:(t-T0)/dt
    %tempt=i*dt;
    M=n*(tt-T0);
    for i=1:length(tt)-1
        
    E(i+1)=M(i+1)+e*sin(E(i));
    end
    x=a*(cos(E)-e);
    y=a*sqrt(1-e*e)*sin(E);
    z=zeros(1,length(tt));
    rr=[x;y;z];
    
    R=a*(1-e*cos(E));
    vx=-n*a*a./R.*sin(E);
    vy=n*a*a./R*sqrt(1-e*e).*cos(E);
    vz=zeros(1,length(tt));
    vv=[vx;vy;vz];
    
    ro=rr;
    vo=vv;
    r=R3(-Omega)*R1(-I)*R3(-omega)*rr;
    v=R3(-Omega)*R1(-I)*R3(-omega)*vv;
    
    
    
%end



end

function [a,e,I,Omega,omega]=cart2kep(r,v)
GM=3.9860044188e14;

%for i=1:length(r(:,1))
    
x=r(1,:);
y=r(2,:);
z=r(3,:);
vx=v(1,:);
vy=v(2,:);
vz=v(3,:);
h=cross(r,v);

Omega=atan2(h(1,:),-h(2,:));
I=atan2(sqrt(h(1,:).*h(1,:)+h(2,:).*h(2,:)),h(3,:));
R=sqrt(x.^2+y.^2+z.^2);
V=sqrt(vx.^2+vy.^2+vz.^2);
a=(2./R-V.^2/GM).^(-1);
H=sqrt(h(1,:).^2+h(2,:).^2+h(3,:).^2);
e=sqrt(1-H.^2./(a*GM));
n=sqrt(GM./(a.^3));
E=atan2((dot([x;y;z],[vx;vy;vz])./(a.^2.*n)),(1-R./a));
%nu=2*atan2(sqrt((1+e)./(1-e)),1./tan(E/2));
nu = atan((sqrt(1-e.^2).* dot([x;y;z],[vx;vy;vz])./(e.*sqrt(GM*a)))./(cos(E)-e));
%u=acos(1./R.*(x.*sin(Omega)+y.*cos(Omega)));

% u(z<0)=2*pi-u(z<0);
% omega=u-nu;
for i=1:length(Omega)
    
P(:,i)=R1(I(i))*R3(Omega(i))*r(:,i);
end
u=atan2(P(2,:),P(1,:));
omega=u-nu;
% for i=1:length(omega)
%     if(omega(i)<0)
%         omega(i)=omega(i)+pi;
%     elseif(omega(i)>0&&omega(i)<pi)
%         omega(i)=omega(i)+2*pi;
%     end
% end
% if(omega<0)
%     omega=omega+pi;
% end
omega(omega<0)=omega(omega<0)+pi;
omega(omega<0)=omega(omega<0)+pi;
%omega(omega<0)=omega(omega<0)+2*pi;
% omega(omega>pi)=omega(omega>pi)-pi;
plot(omega);
% ylim([0,pi]);

% if(omega<0)
%     omega=omega+2*pi;
% elseif(omega>pi)
%     omega=omega-pi;
% end
% a_(i)=a;
% e_(i)=e;
% I_(i)=I;
% Omega_(i)=Omega;
% omega_(i)=omega;

%end

end

function rE=orb2ECEF(r)
wE=2*pi/(24*60*60);
tt=0:10:24*60*60;
for i=1:length(tt)
rE(:,i)=R3(wE*tt(i))*r(:,i);
end
end
