clear all; clc; close all;
% Purpose: 
% draw figures for fully normalized zonal, tesseral and sectorial
% Legendre functions Plm and spherical harmonics Ylm of degree l = 10
% within theta(co-latitude) 0-180 deg. using both rodrigues and Recursive_norm
% method.

%% Associated Legendre Formula (ALF) Plm implemeted in two methods
% 1. Rodrigues Ferrers (normalized)
% 2. Recursive_norm formulas (normalized)
theta = linspace(0,180);
t = cosd(theta);

% Zonal (m = 0)
P10_0_1 = Rodrigues_Ferrers(10,0,t);
P10_0_2 = Recursive_norm(10,0,t);
P10_0_diff = P10_0_1 - P10_0_2;  

% Sectorial (m = l)
P10_10_1 = Rodrigues_Ferrers(10,10,t);
P10_10_2= Recursive_norm(10,10,t);
P10_10_diff = P10_10_1 - P10_10_2;

% Tesseral (m != l)
f3 = figure;
subplot(2,1,1)
P10_m_1 =[];
P10_m_2 =[];
for m = 1:9
    P10_m_1 = [P10_m_1 ; double(Rodrigues_Ferrers(10,m,t))];
    plot(theta ,P10_m_1(m,:));
    hold on
end
f4 = figure;
subplot(2,1,1)
for m = 1:9
    P10_m_2= [P10_m_2; double(Recursive_norm(10,m,t))];
    plot(theta ,P10_m_2(m,:));
    hold on
end
f5 = figure;
subplot(2,1,1)
for m = 1:9
    P10_m_diff = P10_m_1(m,:) - P10_m_2(m,:) ;
    plot(theta ,P10_m_diff);
    hold on
end


%% Spherical harmonic Ylm
lamda = linspace(-180,180,360);
 
% Zonal (m = 0)
Y10_0_1 = spherical_harmonic(10,0,lamda,P10_0_1);
Y10_0_2 = spherical_harmonic(10,0,lamda,P10_0_2);
Y10_0_diff = Y10_0_1 - Y10_0_2;

% Sectorial (m = l)
Y10_10_1 = spherical_harmonic(10,10,lamda,P10_10_1);
Y10_10_2 = spherical_harmonic(10,10,lamda,P10_10_2);
Y10_10_diff = Y10_10_1 - Y10_10_2;

% Tesseral (m != l, m = 4 for example)
Y10_4_1 = spherical_harmonic(10,4,lamda,P10_m_1(4,:));
Y10_4_2 = spherical_harmonic(10,4,lamda,P10_m_2(4,:));
Y10_4_diff = Y10_4_1 - Y10_4_2;

%% plotting

f1 = figure;
subplot(3,2,1) 
plot(theta ,double(P10_0_1));
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('Zonal Legendre function[Rodrigues-Ferrers]')
subplot(3,2,2)
imagesc(lamda,theta,Y10_0_1);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('Zonal spherical harmonic[Rodrigues-Ferrers]')
subplot(3,2,3) 
plot(theta ,double(P10_0_2));
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('Zonal Legendre function[Recursive-method]')
subplot(3,2,4)
imagesc(lamda,theta,Y10_0_2);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('Zonal spherical harmonic[Recursive-method]')
subplot(3,2,5)
plot(theta ,double(P10_0_diff));
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('difference between two methods')
subplot(3,2,6)
imagesc(lamda,theta,Y10_0_diff);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('difference between two methods')


f2 = figure;
subplot(3,2,1) 
plot(theta ,double(P10_10_1));
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('Sectorial Legendre function[Rodrigues-Ferrers]')
subplot(3,2,2) 
imagesc(lamda,theta,Y10_10_1);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('Sectorial spherical harmonic[Rodrigues-Ferrers]')
subplot(3,2,3) 
plot(theta ,double(P10_10_2));
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('Sectorial Legendre function[Recursive-method]')
subplot(3,2,4)
imagesc(lamda,theta,Y10_10_2);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('Sectorial spherical harmonic[Recursive-method]')
subplot(3,2,5)
plot(theta ,double(P10_10_diff));
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('difference between two methods')
subplot(3,2,6)
imagesc(lamda,theta,Y10_10_diff);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('difference between two methods')



figure(f3)
subplot(2,1,1)
legend('m = 1','m = 2','m = 3','m = 4','m = 5','m = 6','m = 7','m = 8','m = 9')
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('Tesseral Legendre functions[Rodrigues-Ferrers]')
subplot(2,1,2)
imagesc(lamda,theta,Y10_4_1);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('Tesseral spherical harmonic m = 4 [Rodrigues-Ferrers]')

figure(f4)
subplot(2,1,1)
legend('m = 1','m = 2','m = 3','m = 4','m = 5','m = 6','m = 7','m = 8','m = 9')
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('Tesseral Legendre functions[Recursive-method]')
subplot(2,1,2)
imagesc(lamda,theta,Y10_4_2);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('Tesseral spherical harmonic m = 4 [Recursive-method]')

figure(f5)
subplot(2,1,1)
legend('m = 1','m = 2','m = 3','m = 4','m = 5','m = 6','m = 7','m = 8','m = 9')
xlabel('\theta [\circ]')
ylabel('Plm')
xlim([0 180]);
title('difference between two methods')
subplot(2,1,2)
imagesc(lamda,theta,Y10_4_diff);
colormap(jet)
xlabel('\lambda [\circ]')
ylabel('\theta [\circ]')
title('difference between two methods')
