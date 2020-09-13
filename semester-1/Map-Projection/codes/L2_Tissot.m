
% Map Projection lab 2
% author: Yi Wang 
% created: 17.11.2018
% last changes: 21.11.2018  correct some mistakes

clc;
clear;
set(0,'defaultfigurecolor','w') 

%% constants and data
load coast.mat;
R=6370;

%% coast
const=R;
[x,y]=collignon(long,lat,const,'map');
plot(x,y);
hold on;

axis equal;
axis off;

%% meridians & parallels
[Lon_m,Lat_m]=meshgrid(-180:30:180,linspace(-90,90,300));
[x_m,y_m]=collignon(Lon_m,Lat_m,const,'map');
plot(x_m,y_m,'color',[0.5,0.5,0.5]);
hold on;

[Lat_p,Lon_p]=meshgrid(-90:30:90,linspace(-180,180,600));
[x_p,y_p]=collignon(Lon_p,Lat_p,const,'map');
plot(x_p,y_p,'color',[0.5,0.5,0.5]);
hold on;

%% Tissot distortion ellipses
[Lon_s,Lat_s]=meshgrid(-180:30:180,-60:30:60);
Lon_s=Lon_s(:);
Lat_s=Lat_s(:);
[G,C,J]=collignon(Lon_s,Lat_s,const,'Tissot');
ra=zeros(65,1);
rb=zeros(65,1);
ang=zeros(65,1);
[x0,y0]=collignon(Lon_s,Lat_s,const,'map');
for i=1:65
    c=[C(i,1),C(i,2);C(i,3),C(i,4)];
    g=[G(i,1),G(i,2);G(i,3),G(i,4)];
    j=[J(i,1),J(i,2);J(i,3),J(i,4)];
    [F,d]=eig(c,g);
    f=j*F;
    ang(i)=atan(f(2,1)/f(1,1));
    ra(i)=sqrt(d(1,1));
    rb(i)=sqrt(d(2,2));
    
end

ra=ra*500;
rb=rb*500;
set(0,'defaultlinelinewidth',0.8);
ellipse(ra,rb,ang,x0,y0,'r');  % little change to the ellipse function so it can also draw axises
    
    





