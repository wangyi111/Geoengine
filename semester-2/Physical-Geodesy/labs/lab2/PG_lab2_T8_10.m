clear;
clc;


load PREM.mat;
r=PREM(:,1);
rho=PREM(:,2);
% G=6.672e-11;
set(0,'defaultfigurecolor','w')
figure(1);
plot(r,rho);
title('PREM model');
xlabel('radial coordinate r (km)');
ylabel('density \rho (kg/m^3)');


figure(2);
subplot(2,1,1);
[V,rv]=V_shell(r,rho);

plot(rv,V);
title('potential');
xlabel('r (km)');
ylabel('V (m^2/s^2)');
subplot(2,1,2);
a=a_shell(r,rho);
plot(r,a);
title('attraction');
xlabel('r (km)');
ylabel('a (m/s^2)');

for i=1:length(rv)
    if(rv(i)==6371)
        V_RE=V(i);
        a_RE=a(i);
        break;
    end
end
disp('At the surface:');
V_RE
a_RE
[max_V,index_V]=max(V);
V_max=max_V;
r_Vmax=r(index_V);
disp('position with largest potential:');
r_Vmax
V_max

[max_a,index_a]=max(abs(a));
a_max=max_a;
r_amax=r(index_a);
disp('position with largest attraction:');
r_amax
a_max

%% potential
% version1: 1.no deeper sampling 2.ignore rho(r=0)
function [V,rv]=V_shell(r,rho)

G=6.672e-11;
n=length(r);
R=r(n);
V1=zeros(n,1);
r=r*1000;
% r=0
V1(1)=2*pi*G*rho(2)*(r(2)*r(2)-1/3*r(1)*r(1));
for j=2:n-1
    V1(1)=V1(1)+2*pi*G*rho(j+1)*(r(j+1)*r(j+1)-r(j)*r(j));
end
% 0<r<RE
for i=2:n
    rr=r(i-1);
    VV1=0;
    for j=2:i-1
        VV1=VV1+4/3*pi*G*rho(j)*((r(j))^3-(r(j-1))^3)/rr;
    end
    VV2=0;
    for j=i+1:n
        VV2=VV2+2*pi*G*rho(j)*((r(j))^2-(r(j-1))^2);
    end
    VV3=2*pi*G*rho(i)*((r(i))^2-1/3*rr^2)-4/3*pi*G*rho(i)*rr^3/rr;
    V1(i)=VV1+VV2+VV3;   
end
% r>RE

r2=R:2*R;
r2=(r2*1000)';
m=length(r2);
V2=zeros(m,1);
M=0;
for i=2:n
    M=M+4/3*pi*(r(i))^3*rho(i)-4/3*pi*(r(i-1))^3*rho(i);
end
for i=1:m
    V2(i)=G*M/r2(i);
end

V=[V1;V2];
rv=[r;r2]/1000;


end

%% acceleration
function [a1,ra]=a_shell(r,rho)

G=6.672e-11;
n=length(r);
R=r(n);
a1=zeros(n,1);
r=r*1000;
% r=0
a1(1)=-4/3*pi*G*rho(2)*r(1);
% 0<r<RE
for i=2:n
    rr=r(i-1);
    aa1=0;
    for j=2:i-1
        aa1=aa1-4/3*pi*G*rho(j)*((r(j))^3-(r(j-1))^3)/(rr^2);
    end
    aa2=0;
    for j=i+1:n
        aa2=aa2+0;
    end
    aa3=-4/3*pi*G*rho(i)*((r(i))^3-rr^3)/((r(i))^2);
    a1(i)=aa1+aa2+aa3;
end
% r>RE
r2=R:2*R;
r2=(r2*1000)';
m=length(r2);
a2=zeros(m,1);
M=0;
for i=2:n
    M=M+4/3*pi*(r(i))^3*rho(i)-4/3*pi*(r(i-1))^3*rho(i);
end
for i=1:m
    a2(i)=G*M/(r2(i))^2;
end

a=[a1;a2];
ra=[r;r2]/1000;
end