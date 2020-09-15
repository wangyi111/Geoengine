clear all; clc; close all;
% Purpose: determine gravity potential W and gravitational potential V 
% at point P with  lamda: 10+k, theta: 42+k, r=6379245.458 m

load('EGM96.txt'); % [l, m, Clm, Slm]

R = 6378136.300; % [m]
GM = 3.986004415 * 10^14; % [m^3*s^-2]
omega = 7.292115 * 10^-5; % [s^-5]

k = (9+3)/2; % our end number of matriculation No. average
lamda = 10 + k;
theta = 42 + k;
t = cosd(theta);
r = 6379245.458; % [m]

%% W = V + Vc
% V
outersum = 0;
for l = 0:36 % EGM96 data provide up to l =36
    innersum = 0;
    for m = 0:l
        % models coefficient
        row = (1+l)*l/2 +1 + m;
        Clm = EGM96(row,3);  
        Slm = EGM96(row,3);
        
        % longitude components
        cos_term = cosd(m * lamda);
        sin_term = sind(m * lamda);
        % lat component
        Pl_m = Recursive_norm(l,m,t);
        % combination Ylm = lat * long 
        Yl_m_c = Pl_m * cos_term;
        Yl_m_s = Pl_m * sin_term;
       
        innersum = innersum + (Clm * Yl_m_c + Slm * Yl_m_s);
    end
    Rr_l1 = (R/r)^(l+1);
    outersum = outersum + Rr_l1 * innersum;
end
V = GM / R * outersum
% Vc
Vc = 1/2 * omega^2 * r^2 * sind(theta)^2;
% W
W = V+Vc

