% This if for Kinematic lab 4
% Written by NianLiu 3294622

clc;
close;
clear;

% initial Height difference of two antenna
dh_ini = 0.79; % m
% ========= General GPS Ublox receiver ===========
% read data
data = load ('KMS_GENERAL.txt');
ID_Ubl = data(:,1);
date = data(:,2);
date_Ubl = date - 115000;
% time in UTC, unit s
UTC_Ubl = fix(date_Ubl/100)*60 + date_Ubl-fix(date_Ubl/100)*100; % s

% XYZ in Cartesian earth coordinate, unit m
X_Ubl = data(:,4);
Y_Ubl = data(:,5);
Z_Ubl = data(:,6);

% Latitude and longitude
lat_Ubl = data(:,7);
long_Ubl = data(:,8);
alt_Ubl = data(:,9);

% ========= GPS-RTK receiver ===========

% read data
data1 = load ('KMS_GPS_RTK.txt');
ID_RTK = data1(:,1);
date_read = data1(:,3);
% date UTC: unit s
date_RTK = date_read - 135000;
UTC_RTK = fix(date_RTK/100)*60 + date_RTK-fix(date_RTK/100)*100; % s
% latitude unit degree
lat_RTK = fix(data1(:,4))+(data1(:,4)-fix(data1(:,4)))/0.6+ data1(:,5)/3600;
% longitude unit degree
long_RTK = fix(data1(:,6))+(data1(:,6)-fix(data1(:,6)))/0.6+ data1(:,7)/3600;
% altitude unit m
alt_RTK = data1(:,8);

data2 = load ('KMS_GPS_RTK_XYZ.txt');
% XYZ in Cartesian earth coordinate, unit m
X_RTK = data2(:,4);
Y_RTK = data2(:,5);
Z_RTK = data2(:,6);

% ========= Calculation part ===========
% ===Calculation of the distance between the two antennas===

d_atenna1 = sqrt((X_Ubl(6:42)-X_RTK(8:44)).^2+(Y_Ubl(6:42)-Y_RTK(8:44)).^2+(Z_Ubl(6:42)-Z_RTK(8:44)).^2);
% during this part, there is a block of trees
d_atenna2 = sqrt((X_Ubl(53:85)-X_RTK(45:77)).^2+(Y_Ubl(53:85)-Y_RTK(45:77)).^2+(Z_Ubl(53:85)-Z_RTK(45:77)).^2);
d_atenna = [d_atenna1;d_atenna2];

% ===Comparison of the calculated distances with reference baseline===
figure(4);
time = [UTC_RTK(8:44);UTC_RTK(45:77)];
plot(time,d_atenna);
hold on;
% plot differences in two antennas
plot(time,dh_ini*ones(70,1));
text(244,0.79,'0.79 m');
hold on;
plot(time,d_atenna-dh_ini*ones(70,1),'^');
title('Comparison of the Calculated Distances with Reference Baseline');
legend('Calculated distance','Reference baseline','Differences per epoch');
xlabel('Time / Epoch (s)');
ylabel('Distance (m)');

% ===Plot driven trajectories for both GNSS receivers===
figure (1);
plot(X_Ubl, Y_Ubl,'o');
text(X_Ubl, Y_Ubl, num2str(ID_Ubl),'FontSize',6);
hold on;
plot(X_RTK, Y_RTK, '*');
text(X_RTK, Y_RTK, num2str(ID_RTK),'FontSize',6);

legend('Ublox receiver','RTK receiver');
title('Trajecories of Two Receivers');
xlabel('Coordinate X (m)');
ylabel('Coordinate Y (m)');
axis([4.15554e6 4.15562e6 6.7471e5 6.7483e5]);

% ===Calculation of the velocities for both receivers===
% for Ublox receiver
dis_Ubl = zeros(84,1);
dt_Ubl = zeros(84,1);
v_Ubl = zeros(84,1);
for i = 1:84
    % distance, m
    dis_Ubl(i) = sqrt((X_Ubl(i+1)-X_Ubl(i))^2+(Y_Ubl(i+1)-Y_Ubl(i))^2+(Z_Ubl(i+1)-Z_Ubl(i))^2);
    % delta time, s
    dt_Ubl(i) = UTC_Ubl(i+1)-UTC_Ubl(i);
    % velocity, m/s
    v_Ubl(i) = dis_Ubl(i)/dt_Ubl(i);
end

% for RTK receiver
dis_RTK = zeros(81,1);
dt_RTK = zeros(81,1);
v_RTK = zeros(81,1);
for i = 1:81
    % distance, m
    dis_RTK(i) = sqrt((X_RTK(i+1)-X_RTK(i))^2+(Y_RTK(i+1)-Y_RTK(i))^2+(Z_RTK(i+1)-Z_RTK(i))^2);
    % delta time, s
    dt_RTK(i) = UTC_RTK(i+1)-UTC_RTK(i);
    % velocity, m/s
    v_RTK(i) = dis_RTK(i)/dt_RTK(i);
end

% Plot both velocities
figure(2);
plot(UTC_Ubl(6:85), v_Ubl(5:84),'--');
hold on;
plot(UTC_RTK(8:77), v_RTK(7:76),'-.');
legend('Ublox receiver','RTK receiver');
title('Velocity for Both Receiver');
xlabel('Time / Epoch (s)');
ylabel('Vecocity (m/s)');


% ===Plot height differencies between two receivers===
dh1 = alt_Ubl(6:42)-alt_RTK(8:44);
dh2 = alt_Ubl(53:85)-alt_RTK(45:77);
dh = [dh1;dh2];
figure(3);
plot(time,dh);
grid on;
title('Height Differences Between Two Receivers');
ylabel('Height differences (m)');
xlabel('Time / Epoch (s)');

