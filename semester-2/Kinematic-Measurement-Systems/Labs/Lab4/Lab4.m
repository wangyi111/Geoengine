% Kinematic Measurement System Lab 4
% GNSS Measurements
%
%
% 30.05.2019

clear
close all
% clc
%% Undetermined data
D_ref=2
% Problems: reference baseline is not given and there's no value of
% longtitude , latitude and altitude data in Leica RTK measurements
%% Data import
% load data

[ID_RTK,Str,m,d,y,hh_RTK,mm_RTK,ss_RTK,Str,Str,Str,X_RTK,Y_RTK,Z_RTK,u_RTK]=textread('LEICA_Cartesianl.txt','%d %s %d/%d/%d %d:%d:%d %s%s%s %f %f %f %f');
[ID_UBL,hh_UBL,mm_UBL,ss_UBL,m1,d1,y1,Lat_UBL,Long_UBL,Alt_UBL,u1_UBL,X_UBL,Y_UBL,Z_UBL,u2_UBL]=textread('UBLOX.txt','%d %d:%d:%f %d/%d/%d %f %f %f %f %f %f %f %f');
% set time
Time_RTK=hh_RTK*60*60+mm_RTK*60+ss_RTK;
Time_UBL=hh_UBL*60*60+mm_UBL*60+ss_UBL;

%% Computation and Analysis of the distance
% Calculation of the distance between the two antennas
D = sqrt((X_UBL-X_RTK).^2+(Y_UBL-Y_RTK).^2+(Z_UBL-Z_RTK).^2);
% Comparison of the calculated distances with reference baseline
D0= ones(size(D))*D_ref;
delta= D-D0;
% visualize
figure(1)
hold on
grid on
plot(Time_RTK-Time_RTK(1),D0);
plot(Time_RTK-Time_RTK(1),D);
plot(Time_RTK-Time_RTK(1),delta);
title('Comparison of the Calculated Distances with Reference Baseline');
legend('Reference baseline','Calculated distance','Differences per epoch');
xlabel('Time(s)');
ylabel('Distance (m)');
%% Plot of the driven trajectors for both GNSS receivers
% Due to the void of longtitude and latitude data in RTK, use [X,Y,Z] corrdinates instead
figure(2)
subplot(3,2,1:4);
hold on
grid on
plot(X_RTK,Y_RTK,'o');
plot(X_UBL,Y_UBL,'*');
% plot3(X_RTK,Y_RTK,Z_RTK,'o');
% plot3(X_UBL,Y_UBL,Z_UBL,'o');
legend('RTK receiver','UBL receiver');
title('Trajecories of Two Receivers');
xlabel('X(m)');
ylabel('Y(m)');
subplot(3,2,5:6);
hold on
plot(Time_RTK-Time_RTK(1),Z_RTK);
plot(Time_RTK-Time_RTK(1),Z_UBL);
legend('RTK receiver','U-Blox receiver');
xlabel('T(s)');
ylabel('Z(m)');

%% Calculation of Velocities for both receivers
% RTK
for i = 1:length(X_RTK)-1
    % distance, m
    D_RTK(i) = sqrt((X_RTK(i+1)-X_RTK(i))^2+(Y_RTK(i+1)-Y_RTK(i))^2+(Z_RTK(i+1)-Z_RTK(i))^2);
    % delta time, s
    dt_RTK(i) = Time_RTK(i+1)-Time_RTK(i);
    % velocity, m/s
    v_RTK(i) = D_RTK(i)/dt_RTK(i);
end
% UBL
for i = 1:length(X_UBL)-1
    % distance, m
    D_UBL(i) = sqrt((X_UBL(i+1)-X_UBL(i))^2+(Y_UBL(i+1)-Y_UBL(i))^2+(Z_UBL(i+1)-Z_UBL(i))^2);
    % delta time, s
    dt_UBL(i) = Time_UBL(i+1)-Time_UBL(i);
    % velocity, m/s
    v_UBL(i) = D_UBL(i)/dt_UBL(i);
end
% visualize
figure(3);
plot(Time_UBL(2:length(Time_UBL))-Time_UBL(1), v_UBL);
hold on;
plot(Time_RTK(2:length(Time_RTK))-Time_RTK(1), v_RTK,'--');

legend('U-Blox receiver','RTK receiver');
title('Velocity for Both Receiver');
xlabel('Time(s)');
ylabel('Vecocity (m/s)');

%% Plot Height defference
% Due to the void of altitude data in RTK, use Z corrdinates instead
dH=Z_UBL-Z_RTK;
% visualize
figure (4)
hold on
plot(Time_RTK-Time_RTK(1),dH);
grid on;
title('Height Differences Between Two Receivers');
ylabel('Height differences (m)');
xlabel('Time (s)');

