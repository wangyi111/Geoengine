% map projection lab3: meta-coordinate system
% author: Yi Wang
% last change: 07/12/2018

clear;
clc;
% change degree to rad
lambda1=deg2rad(116+23/60);
phi1=deg2rad(39+56/60);

lambda2=deg2rad(115+51/60);
phi2=deg2rad(-31-57/60);

lambda_stutt=deg2rad(9+11/60);
phi_stutt=deg2rad(48+46/60);

lambda_Ka=deg2rad(85+20/60);   phi_Ka=deg2rad(27+42/60);
lambda_Ca=deg2rad(-7-37/60);   phi_Ca=deg2rad(33+36/60);
lambda_Se=deg2rad(-122-20/60); phi_Se=deg2rad(47+37/60);

%load coast line
load coast.mat;
Lon=long/180*pi;
Lat=lat/180*pi;






%% rotation method: Beijing

% calculate ohm
[ohm1,~]=rotation(0,lambda1,phi1,lambda_stutt,phi_stutt);
% check the meta coordinates of stuttgart
[A_1_stutt,B_1_stutt]=rotation(ohm1,lambda1,phi1,lambda_stutt,phi_stutt);
[x_1_stutt,y_1_stutt]=bonne(A_1_stutt,B_1_stutt);
% check the meta coordinates of Beijing
[A_1_bj,B_1_bj]=rotation(ohm1,lambda1,phi1,lambda1,phi1); % A_1_r!=0: "x*=3e-17,y*=-5e-17"
A_1_bj=0;
[x_1_BJ,y_1_BJ]=bonne(A_1_bj,B_1_bj);
% calculate the meta coordinates and Cartesian coordinates of the three locations
[A_1_Ka,B_1_Ka]=rotation(ohm1,lambda1,phi1,lambda_Ka,phi_Ka);
[x_1_Ka,y_1_Ka]=bonne(A_1_Ka,B_1_Ka);
[A_1_Ca,B_1_Ca]=rotation(ohm1,lambda1,phi1,lambda_Ca,phi_Ca);
[x_1_Ca,y_1_Ca]=bonne(A_1_Ca,B_1_Ca);
[A_1_Se,B_1_Se]=rotation(ohm1,lambda1,phi1,lambda_Se,phi_Se);
[x_1_Se,y_1_Se]=bonne(A_1_Se,B_1_Se);
% calculate meta coast line
[Lon_1,Lat_1]=metatransform(ohm1,lambda1,phi1,Lon,Lat);
Lon_1(abs(Lon_1)>pi)=NaN; 
Lat_1(abs(Lat_1)>pi/2)=NaN;

[x_1,y_1]=bonne(Lon_1,Lat_1);
figure(1);
plot(x_1,y_1);
hold on;
plot(x_1_stutt,y_1_stutt,'go','MarkerFaceColor','g'); hold on;
plot(x_1_BJ,y_1_BJ,'ro','MarkerFaceColor','r'); hold on;
plot(x_1_Ka,y_1_Ka,'rs','MarkerFaceColor','k'); hold on;
plot(x_1_Ca,y_1_Ca,'rd','MarkerFaceColor','k'); hold on;
plot(x_1_Se,y_1_Se,'rv','MarkerFaceColor','k'); hold on;

title('meta-Beijing Bonne projection');
legend('coast line','stuttgart','Beijing','Kathmandu','Casablanca','Seattle');

%% direct formula: Perth
% calculate ohm
ohm2=atan(sin(lambda_stutt-lambda2)/(sin(phi2)*cos(lambda_stutt-lambda2)-cos(phi2)*tan(phi_stutt)));
% check the meta coordinates of stuttgart
[A_2_stutt,B_2_stutt]=metatransform(ohm2,lambda2,phi2,lambda_stutt,phi_stutt);
[x_2_stutt,y_2_stutt]=bonne(A_2_stutt,B_2_stutt);
% check the meta coordinates of Perth
[A_2_Pe,B_2_Pe]=metatransform(ohm2,lambda2,phi2,lambda2,phi2); % A_2_bj=NaN: "0/0" in the formula 
A_2_Pe=0;
[x_2_Pe,y_2_Pe]=bonne(A_2_Pe,B_2_Pe);
% calculate the meta coordinates and Cartesian coordinates of the three locations
[A_2_Ka,B_2_Ka]=metatransform(ohm2,lambda2,phi2,lambda_Ka,phi_Ka);
[x_2_Ka,y_2_Ka]=bonne(A_2_Ka,B_2_Ka);
[A_2_Ca,B_2_Ca]=metatransform(ohm2,lambda2,phi2,lambda_Ca,phi_Ca);
[x_2_Ca,y_2_Ca]=bonne(A_2_Ca,B_2_Ca);
[A_2_Se,B_2_Se]=metatransform(ohm2,lambda2,phi2,lambda_Se,phi_Se);
[x_2_Se,y_2_Se]=bonne(A_2_Se,B_2_Se);
% calculate meta coast line
[Lon_2,Lat_2]=metatransform(ohm2,lambda2,phi2,Lon,Lat);
[x_2,y_2]=bonne(Lon_2,Lat_2);

figure(2);
plot(x_2,y_2);
hold on;
plot(x_2_stutt,y_2_stutt,'go','MarkerFaceColor','g'); hold on;
plot(x_2_Pe,y_2_Pe,'ro','MarkerFaceColor','r'); hold on;
plot(x_2_Ka,y_2_Ka,'rs','MarkerFaceColor','k'); hold on;
plot(x_2_Ca,y_2_Ca,'rd','MarkerFaceColor','k'); hold on;
plot(x_2_Se,y_2_Se,'rv','MarkerFaceColor','k'); hold on;
title('meta-Perth Bonne projection');
legend('coast line','stuttgart','Perth','Kathmandu','Casablanca','Seattle');

%% normal projection

figure(3);
[x,y]=bonne(Lon,Lat);
plot(x,y);
hold on;
[x_st,y_st]=bonne(lambda_stutt,phi_stutt);
[x_bj,y_bj]=bonne(lambda1,phi1);
[x_pe,y_pe]=bonne(lambda2,phi2);

plot(x_st,y_st,'go','MarkerFaceColor','g'); hold on;
plot(x_bj,y_bj,'ro','MarkerFaceColor','r'); hold on;
plot(x_pe,y_pe,'yo','MarkerFaceColor','y'); hold on;

title('normal Bonne projection');
legend('coast line','stuttgart','Beijing','Perth');

%% functions 
% function: calculate A,B by rotation
function [A,B]=rotation(ohm,lambda0,phi0,lambda,phi)

R=1;
X=R*cos(phi).*cos(lambda);
Y=R*cos(phi).*sin(lambda);
Z=R*sin(phi);

delta=pi/2-phi0;

R32=[cos(ohm),sin(ohm),0;-sin(ohm),cos(ohm),0;0,0,1];
R2=[cos(delta),0,-sin(delta);0,1,0;sin(delta),0,cos(delta)];
R31=[cos(lambda0),sin(lambda0),0;-sin(lambda0),cos(lambda0),0;0,0,1];

XYZ_star=(R32*R2*R31*[X,Y,Z]')';
X_star=XYZ_star(1);
Y_star=XYZ_star(2);
Z_star=XYZ_star(3);

A=atan(Y_star./X_star);
B=atan(Z_star./(X_star.^2+Y_star.^2)^0.5);

end
% function: calculate A,B by direct formula
function [A,B]=metatransform(ohm,lambda0,phi0,lambda,phi)

A=atan(sin(lambda-lambda0)./(sin(phi0)*cos(lambda-lambda0)-cos(phi0)*tan(phi)))-ohm;
B=asin(sin(phi)*sin(phi0)+cos(phi)*cos(phi0).*cos(lambda-lambda0));

end
% function: Bonne Projection 
function [x,y]=bonne(lambda,phi)

    R=1;
    phi0=20;
    delta=phi0+cot(phi0)-phi;
    theta=lambda.*cos(phi)./delta;
    x=R*delta.*cos(theta);
    y=R*delta.*sin(theta);

end



