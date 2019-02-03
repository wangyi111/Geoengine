%% Map Projection Lab4
% author: Yi Wang & Yifei Zheng
% last change: 03/02/2019

clear;
clc;

format long g;

%% GRS80 Ellipsoid 
A_G=6378137;  %m
E2_G=0.00669438002;  %

%% Bessel Ellipsoid
A_B=6377397.155;
E2_B=0.0066743722;

%% GRS80 ellipsoidal coordinates of Kirche and Kuhlenberg
% Data of Yi Wang
% BP=48+0/60+46.4802/3600;  %degree  
% LP=9+54/60+34.7839/3600;  %degree

% Data of Yifei Zheng
BP=48+35/60+35.9492/3600;  %degree  
LP=8+45/60+0.3857/3600;  %degree

%% Gauss–Krüger coordinates
L0=9;  %degree
B0=48;  %degree
X0=5400000;
%% UTM coordinates
zone=32;

%% main
% exercise 1: ellipsoidal to conformal
disp("[Exercise 1: ellipsoidal to conformal coordinates]");

[X1,Y1,c1,lambda1]=ellip2conformal(A_G,E2_G,L0,B0,LP,BP,'Gauss');
X_Gauss=X1
Y_Gauss=Y1+500000+L0/3*10^6
c_Gauss=deg2dms(c1)
lambda_Gauss=lambda1
[X2,Y2,c2,lambda2]=ellip2conformal(A_G,E2_G,L0,B0,LP,BP,'UTM');
X_UTM=X2
Y_UTM=Y2+500000
c_UTM=deg2dms(c2)
lambda_UTM=lambda2

% exercise 2: conformal to ellipsoidal
disp("[Exercise 2: conformal to ellipsoidal coordinates]");

[B1,L1,c11,lambda11]=cartesian2ellip(A_B,E2_B,L0,X0,X1,Y1,'Gauss');
B_Gauss=deg2dms(B1)
L_Gauss=deg2dms(L1)
c11=deg2dms(c11)
lambda11
[B2,L2,c22,lambda22]=cartesian2ellip(A_B,E2_B,L0,X0,X2,Y2,'UTM');
B_UTM=deg2dms(B2)
L_UTM=deg2dms(L2)
c22=deg2dms(c22)
lambda22

disp("[2.2.Influence of the changed geometry (unit: m)]");
influence=lat2mer(A_B, E2_B, deg2rad(B2))-lat2mer(A_G, E2_G, deg2rad(BP))


%% function 1  ellipsoidal to conformal
function [X,Y,c,lambda]=ellip2conformal(A,E2,L0,B0,LP,BP,proj)
% easting Y=y(l,b); 
% (False)Northing X(l,B)=X0+x(l,b);
E=sqrt(E2);
l=LP-L0;
b=BP-B0;

% check size of l and b
if abs(b)>1
    error('unacceptable b');
end

% scale of central meridian
switch proj
    case 'Gauss'
        m0=1;
        if abs(l)>3.5
            error('unacceptable l');
        end
    case 'UTM'
        m0=0.9996;
        if abs(l)>6.5
            error('unacceptable l');
        end
end

B0=deg2rad(B0);
l=deg2rad(l);
b=deg2rad(b);

% X0
e0 = 1-1/4*E^2-3/64*E^4-5/256*E^6-175/16384*E^8-441/66536*E^10;
e2 = -3/8*E^2-3/32*E^4-45/1024*E^6-105/4096*E^8-2205/131072*E^10;
e4 = 15/256*E^4+45/1024*E^6+525/16384*E^8+1575/65536*E^10;
e6 = -35/3072*E^6-175/12288*E^8-3675/262144*E^10;
e8 = 315/131072*E^8+2205/524288*E^10;
e10 = -693/1310720*E^10;
G0=A*(e0*B0 + e2*sin(2*B0) + e4*sin(4*B0) + e6*sin(6*B0) + e8*sin(8*B0) + e10*sin(10*B0));
X0=G0*m0;


N=A/sqrt(1-E2*(sin(B0))^2);
M=A*(1-E2)/(1-E2*(sin(B0))^2)^(3/2);
t=tan(B0);
n=sqrt(E2/(1-E2))*cos(B0);

% X,Y
cxy10= m0*N*(1-n^2+n^4-n^6);
cxy20= 3*m0/2*N*t*(n^2-2*n^4);
cxy02= m0/2*N*t*cos(B0)*cos(B0);
cxy30= m0/2*N*(n^2*(1-t^2)+n^4*(-2+7*t^2));
cxy12= m0/2*N*(1-t^2+n^2*t^2-n^4*t^2)*cos(B0)*cos(B0);
cxy40= -m0/2*N*n^2*t;
cxy22= m0/4*N*t*(-4+3*n^2*(1-t^2))*cos(B0)*cos(B0);
cxy04= m0/24*N*t*(5-t^2+9*n^2)*cos(B0)*cos(B0)*cos(B0)*cos(B0);
cxy32= m0/3*N*(-1+t^2)*cos(B0)*cos(B0);
cxy14= m0/24*N*(5-18*t^2+t^4+n^2*(9-40*t^2-t^4))*(cos(B0))^4;
cxy42= m0/3*N*t*cos(B0)*cos(B0);
cxy24= m0/6*N*t*(-7+5*t^2)*(cos(B0))^4;
cxy06= m0/720*N*t*(61-58*t^2+t^4)*(cos(B0))^6;
cxy16= m0/720*N*(61-479*t^2+179*t^4-t^6)*(cos(B0))^6;
cxy01= m0*N*cos(B0);
cxy11= m0*N*t*(-1+n^2-n^4)*cos(B0);
cxy21= m0/2*N*(-1+n^2*(1-3*t^2)+n^4*(-1+6*t^2))*cos(B0);
cxy03= m0/6*N*(1-t^2+n^2)*(cos(B0))^3;
cxy31= m0/6*N*t*(1+n^2*(-10+3*t^2))*cos(B0);
cxy13= m0/6*N*t*(-5+t^2-n^2*(4+t^2))*(cos(B0))^3;
cxy41= m0/24*N*cos(B0);
cxy23= m0/12*N*(-5+13*t^2+n^2*(-4+8*t^2+3*t^4))*(cos(B0))^3;
cxy05= m0/120*N*(5-18*t^2+t^4+n^2*(14-58*t^2))*(cos(B0))^5;
cxy33= m0/36*N*t*(41-13*t^2)*(cos(B0))^3;
cxy15= m0/120*N*t*(-61+58*t^2-t^4)*(cos(B0))^5;
cxy25= m0/240*N*(-61+418*t^2-121*t^4)*(cos(B0))^5;

x = cxy10*b + cxy20*b^2 + cxy02*l^2 + cxy30*b^3 + cxy12*b*l^2 + cxy40*b^4 + cxy22*b^2*l^2 + cxy04*l^4 + cxy32*b^3*l^2 + cxy14*b*l^4 + cxy42*b^4*l^2 + cxy24*b^2*l^4 + cxy06*l^6 + cxy16*b*l^6;
y = cxy01*l + cxy11*b*l + cxy21*b^2*l + cxy03*l^3 + cxy31*b^3*l + cxy13*b*l^3 + cxy41*b^4*l + cxy23*b^2*l^3+ cxy05*l^5 + cxy33*b^3*l^3 + cxy15*b*l^5 + cxy25*b^2*l^5;

X=X0+x;
Y=y;


% meridian convergence c and distortion(scale) lambda

cc01= t*cos(B0);
cc11= cos(B0);
cc21= -t/2*cos(B0);
cc03= 1/3*t*(1+3*n^2)*(cos(B0))^3;
cc31= -1/6*cos(B0);
cc13= 1/3*(1-2*t^2+n^2*(3-12*t^2))*(cos(B0))^3;
cc23= 1/6*t*(-7+2*t^2)*(cos(B0))^3;
cc05= 1/15*t*(2-t^2)*(cos(B0))^5;

clambda02= m0/2*(1+n^2)*(cos(B0))^2;
clambda12= -m0*t*(1+2*n^2)*(cos(B0))^2;
clambda22= m0/2*(-1+t^2+n^2*(-2+6*t^2))*(cos(B0))^2;
clambda04= m0/24*(5-4*t^2+n^2*(14-28*t^2))*(cos(B0))^4;
clambda32= 2*m0/3*t*(cos(B0))^2;
clambda14= m0/6*t*(-7+2*t^2)*(cos(B0))^4;
clambda06= m0/720*(61-148*t^2+16*t^4)*(cos(B0))^6;

c = cc01*l + cc11*b*l + cc21*b^2*l + cc03*l^3 + cc31*b^3*l + cc13*b*l^3 + cc23*b^2*l^3 + cc05*l^5;
lambda = m0 + clambda02*l^2 + clambda12*b*l^2 + clambda22*b^2*l^2 + clambda04*l^4 + clambda32*b^3*l^2 + clambda14*b*l^4 + clambda06*l^6;
c=rad2deg(c);

end

%% function 2: conformal to ellipsoidal
function [B,L,c,lambda]=cartesian2ellip(A,E2,L0,X0,X,Y,proj)
%

L0=deg2rad(L0);

x=X-X0;
y=Y;

if abs(x)>100000
    error('unacceptable x');
end



switch proj
    case 'Gauss'
        m0=1;   
    case 'UTM'
        m0=0.9996;
end


% B0
G = X0/m0;
e_0  = A * (1 - 1/4 * E2 - 3/64 * E2^2 -    5/256 * E2^3 - 175/16384 * E2^4 -       411/65536 * E2^5);
F_2  =          3/8 * E2 + 3/16 * E2^2 + 213/2048 * E2^3 +  255/4096 * E2^4 +   166479/655360 * E2^5;
F_4  =                   21/256 * E2^2 +   21/256 * E2^3 +  533/8192 * E2^4 -   120563/327680 * E2^5;
F_6  =                                   151/6144 * E2^3 +  147/4096 * E2^4 + 2732071/9175040 * E2^5;
F_8  =                                                   1097/131072 * E2^4 -  273697/4587520 * E2^5;

Ge = G / e_0;
B0 = Ge + F_2 * sin(2 * Ge) + F_4 * sin(4 * Ge) + F_6 * sin(6 * Ge) + F_8 * sin(8 * Ge);

if abs(y)>2/180*pi*6380000*cos(B0)
    error('unacceptable y');
end

N = A/sqrt(1-E2*(sin(B0))^2);
t = tan(B0); 
n = sqrt(E2/(1-E2))*cos(B0); 

% b,l 
cbl10= (1)*(1+n^2)/(m0*N);
cbl20= -(3*t)*(n^2+n^4)/(2*(m0^2*N^2));
cbl02= -(1*t)*(1+n^2)/(2*(m0^2*N^2));
cbl30= (1)*(n^2*(-1+t^2)+n^4*(-2+6*t^2))/(2*(m0^3*N^3));
cbl12= (1)*(-1-t^2+n^2*(-2+2*t^2)+n^4*(-1+3*t^2))/(2*(m0^3*N^3));
cbl40= (1)*t*n^2/(2*(m0^4*N^4));
cbl22= (1*t)*(-2-2*t^2+n^2*(9+t^2))/(4*(m0^4*N^4));
cbl04= (1*t)*(5+3*t^2+n^2*(6-6*t^2))/(24*(m0^4*N^4));
cbl32= (1)*(-2-8*t^2-6*t^4+n^2*(7-6*t^2+3*t^4))/(12*(m0^5*N^5));
cbl14= (1)*(5+14*t^2+9*t^4+n^2*(11-30*t^2-9*t^4))/(24*(m0^5*N^5));
cbl42= -(1*t)*(2+5*t^2+3*t^4)/(6*(m0^6*N^6));
cbl24= (1*t)*(7+16*t^2+9*t^4)/(12*(m0^6*N^6));
cbl06= -(1*t)*(61+90*t^2+45*t^4)/(720*(m0^6*N^6));
cbl34= (1)*(7+55*t^2+93*t^4+45*t^6)/(36*(m0^7*N^7));
cbl16= -(1)*(61+331*t^2+495*t^4+225*t^6)/(720*(m0^7*N^7));

cbl01= 1/(m0*N*cos(B0));
cbl11= 1*t/(m0^2*N^2*cos(B0));
cbl21= (1)*(1+2*t^2+n^2)/(2*(m0^3*N^3*cos(B0)));
cbl03= -(1)*(1+2*t^2+n^2)/(6*(m0^3*N^3*cos(B0)));
cbl31= (1*t)*(5+6*t^2+n^2)/(6*(m0^4*N^4*cos(B0)));
cbl13= -(1*t)*(5+6*t^2+n^2)/(6*(m0^4*N^4*cos(B0)));
cbl41= (1)*(5+28*t^2+24*t^4)/(24*(m0^5*N^5*cos(B0)));
cbl23= -(1)*(5+28*t^2+24*t^4+n^2*(6+8*t^2))/(12*(m0^5*N^5*cos(B0)));
cbl05= (1)*(5+28*t^2+24*t^4+n^2*(6+8*t^2))/(120*(m0^5*N^5*cos(B0)));
cbl33= -(1*t)*(61+180*t^2+120*t^4)/(36*(m0^6*N^6*cos(B0)));
cbl15= (1*t)*(61+180*t^2+120*t^4)/(120*(m0^6*N^6*cos(B0)));
cbl25= (1)*(61+662*t^2+1320*t^4+720*t^6)/(240*(m0^7*N^7*cos(B0)));
cbl07= -(1)*(61+662*t^2+1320*t^4+720*t^6)/(5040*(m0^7*N^7*cos(B0)));

b = cbl10*x + cbl20*x^2 + cbl02*y^2 + cbl30*x^3 + cbl12*x*y^2 + cbl40*x^4 + cbl22*x^2*y^2 + cbl04*y^4 + cbl32*x^3*y^2 + cbl14*x*y^4 + cbl42*x^4*y^2 + cbl24*x^2*y^4 + cbl06*y^6 + cbl34*x^3*y^4 + cbl16*x*y^6;
l = cbl01*y + cbl11*x*y + cbl21*x^2*y + cbl03*y^3 + cbl31*x^3*y + cbl13*x*y^3 + cbl41*x^4*y + cbl23*x^2*y^3+ cbl05*y^5 + cbl33*x^3*y^3 + cbl15*x*y^5 + cbl25*x^2*y^5 + cbl07*y^7;

B=B0+b;
L=L0+l;
B=rad2deg(B);
L=rad2deg(L);

% c,lambda
cc01= 1*t/(m0*N);
cc11= (1)*(1+t^2+n^2)/(m0^2*N^2);
cc21= (1*t)*(1+t^2-n^2)/(m0^3*N^3);
cc03= -(1*t)*(1+t^2-n^2)/(3*(m0^3*N^3));
cc31= (1)*(1+4*t^2+3*t^4)/(3*(m0^4*N^4));
cc13= -(1)*(1+4*t^2+3*t^4)/(3*(m0^4*N^4));
cc41= (1*t)*(2+5*t^2+3*t^4)/(3*(m0^5*N^5));
cc23= -(2*t)*(2+5*t^2+3*t^4)/(3*(m0^5*N^5));
cc05= (1*t)*(2+5*t^2+3*t^4)/(15*(m0^5*N^5));
cc33= -(2)*(2+17*t^2+30*t^4+15*t^6)/(9*(m0^6*N^6));
cc15= (1)*(2+17*t^2+30*t^4+15*t^6)/(15*(m0^6*N^6));
cc25= (1*t)*(17+77*t^2+105*t^4+45*t^6)/(15*(m0^7*N^7));

clambda02 = (1)*(1+n^2)/(2*m0*N^2);
clambda12 = -2*t*n^2/(m0^2*N^3);
clambda22 = 1*n^2*(-1+t^2)/(m0^3*N^4);
clambda04 = 1*(1+6*n^2)/(24*m0^3*N^4);

c = cc01*y + cc11*x*y + cc21*x^2*y + cc03*y^3 + cc31*x^3*y + cc13*x*y^3 + cc41*x^4*y + cc23*x^2*y^3 + cc05*y^5 + cc33*x^3*y^3 + cc15*x*y^5 + cc25*x^2*y^5;
lambda = m0 + clambda02*y^2 + clambda12*x*y^2 + clambda22*x^2*y^2 + clambda04*y^4;
c=rad2deg(c);
end

%% function 3: arc length
function G = lat2mer(A, E2, B)
% Meridional arc length G from equator until ellipsoidal latitude B
% IN:
%    A ..... semi major axis of reference ellipsoid in [m]
%    E2 .... square of 1st numerical excentricity of 
%            reference ellipsoid in [-]
%    B ..... ellipsoidal latitude in [rad]
% OUT:
%    G ..... meridional arc length in [m]

% -------------------------------------------------------------------------
% authors:
%    Matthias ROTH (MR), GI, Uni Stuttgart
% -------------------------------------------------------------------------
% revision history:
%    2016-01-19: MR, brush up help text
%    2011-12-20: MR, inital version after "geomed_merbod.pdf"
% -------------------------------------------------------------------------


e_0  = 1 - 1/4 * E2 - 3/64 * E2^2 -   5/256 * E2^3 - 175/16384 * E2^4 -   441/65536 * E2^5;
e_2  =    -3/8 * E2 - 3/32 * E2^2 - 45/1024 * E2^3 -  105/4096 * E2^4 - 2205/131072 * E2^5;
e_4  =              15/256 * E2^2 + 45/1024 * E2^3 + 525/16384 * E2^4 +  1575/65536 * E2^5;
e_6  =                             -35/3072 * E2^3 - 175/12288 * E2^4 - 3675/262144 * E2^5;
e_8  =                                              315/131072 * E2^4 + 2205/524288 * E2^5;
e_10 =                                                                 -693/1310720 * E2^5;

G   = A * (e_0 * B + e_2 * sin(2 * B) + e_4 * sin(4 * B) + e_6 * sin(6 * B) + e_8 * sin(8 * B) + e_10 * sin(10 * B));
end

%% fucntion 4: decimal degree to degree,minute,second
function [c] = deg2dms(c_deg)

c_d = fix(c_deg);
c_m = fix((c_deg - c_d) * 60);
c_s = (c_deg - c_d - c_m/60) * 3600;
c_s = roundn(c_s,-4);
c=[c_d,c_m,c_s];
end

