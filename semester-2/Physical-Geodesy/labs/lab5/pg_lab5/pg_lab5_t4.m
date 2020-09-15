close all;
clear;
clc;

k=6;
data=load('EGM96.txt');
L=data(:,1);
M=data(:,2);
C=data(:,3);
S=data(:,4);

n=length(L);
theta=(42+k)/180*pi;
lambda=(10+k)/180*pi;

r=6379245.458;
R=6378136.3;
GM=3.986004415e14;
w=7.292115e-5;
temp2=0;
for l=0:36
    temp1=0;
    for m=0:l
        
        i=(1+l+1)*(l+1)/2-(l-m);
        c=C(i);
        s=S(i);
        P=double(RF_P(l,m,cos(theta)));
        temp1=temp1+P*(c*cos(m*lambda)+s*sin(m*lambda));
        
    end
    temp2=temp2+(R/r)^(l+1)*temp1;
end
V=GM/R*temp2
Vc=1/2*w^2*r^2*(sin(theta))^2;
W=V+Vc
        
        