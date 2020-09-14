% This script is for Kinematic Lab 3
% Written by Nian LIU 3294622
clc;
clear;
close;

% Load data
data1 = xlsread('velocity1_modify.xlsx');
data2 = xlsread('velocity2.xlsx');
% data3 = xlsread('Station.xlsx');

% Timestamp in seconds
time_stamp1 = data1(:,1)/1000; % s
time_stamp2 = data2(:,1)/1000; % s

% Horizontal angle in rad (gon to rad)
Hz1 = data1(:,2)*360/400*pi/180;
Hz2 = data2(:,2)*360/400*pi/180;

% Vertival angle in rad gon to rad)
V1 = data1(:,3)*360/400*pi/180;
V2 = data2(:,3)*360/400*pi/180;

% Slope distance in meter
Slope1 = data1(:,4);
Slope2 = data2(:,4);

% coordinate Y in meter
Y1 = data1(:,5);
Y2 = data2(:,5);

% coordinate X in meter
X1 = data1(:,6);
X2 = data2(:,6);

% difference between reference line and actual coordinate in meter
ds1 = data1(:,7);
ds2 = data2(:,7);

% Coordinate of the tachymeter
X_s = 4.71093; % m
Y_s = 2.25322; % m
Ori = 2.10441; % rad

%========================================================

% Smoothing of lateral deviation
Lat_dev1 = movmean(ds1,5);
Lat_dev2 = movmean(ds2,5);

% Calculate the difference between max and min of the lateral deviation
delta_Lat_dev1 = max(Lat_dev1)-min(Lat_dev1); 
delta_Lat_dev2 = max(Lat_dev2)-min(Lat_dev2); 

% Calculate the mean velocity
% Pre-allocate memory
d_delta1 = zeros(length(X1),1);
dt1 = zeros(length(X1),1);
velocity1 = zeros(length(X1),1);
d_delta2 = zeros(length(X2),1);
dt2 = zeros(length(X2),1);
velocity2 = zeros(length(X2),1);

% For the velocity 1
for i=1:length(X1)-1
    d_delta1(i+1) = sqrt((X1(i+1)-X1(i))^2+(Y1(i+1)-Y1(i))^2);
    dt1(i+1) = time_stamp1(i+1)-time_stamp1(i);
    velocity1(i+1) = d_delta1(i+1)/dt1(i+1);
end

% For the velocity 2
for i=1:length(X2)-1
    d_delta2(i+1) = sqrt((X2(i+1)-X2(i))^2+(Y2(i+1)-Y2(i))^2);
    dt2(i+1) = time_stamp2(i+1)-time_stamp2(i);
    velocity2(i+1) = d_delta2(i+1)/dt2(i+1);
end

% Mean value of two velocities 
Mean_v1 = mean(velocity1,'omitnan'); % m/s
Mean_v2 = mean(velocity2,'omitnan'); % m/s

% Synchronizaiton error:
delta_t1 =  delta_Lat_dev1/Mean_v1;
delta_t2 =  delta_Lat_dev2/Mean_v2;

% Real horizontal distance
% Conversion of slope distance to horizontal distance
S_H1 = Slope1 .* sin(V1);
S_H2 = Slope2 .* sin(V2);

% Computation of real distance
S_real1=zeros(length(S_H1),1);
S_real2=zeros(length(S_H2),1);

for i=1:length(S_H1)-1
    S_real1(i+1) = S_H1(i+1) + delta_t1/(time_stamp1(i+1)-time_stamp1(i))*(S_H1(i)-S_H1(i+1));
end
for i=1:length(S_H2)-1
    S_real2(i+1) = S_H2(i+1) + delta_t2/(time_stamp2(i+1)-time_stamp2(i))*(S_H2(i)-S_H2(i+1));
end

% Corrected Coordinates
X_Corr1 = X_s + S_real1.*cos(Ori+Hz1);
Y_Corr1 = Y_s + S_real1.*sin(Ori+Hz1);

X_Corr2 = X_s + S_real2.*cos(Ori+Hz2);
Y_Corr2 = Y_s + S_real2.*sin(Ori+Hz2);

% Pick out the initial point(due to the Pre-allocate memory) 
X_Corr1 = X_Corr1(2:764);
Y_Corr1 = Y_Corr1(2:764);
X_Corr2 = X_Corr2(2:357);
Y_Corr2 = Y_Corr2(2:357);


% Plot part
% XY coordinates of the prism
figure(1);
plot(X1,Y1);
title('Coordinates of the Prism in Velocity 1');
xlabel('X (m)');
ylabel('Y (m)');

figure(2);
plot(X2,Y2);
title('Coordinates of the Prism in Velocity 2');
xlabel('X (m)');
ylabel('Y (m)');

% Lateral deviations and smoothed lateral deviation 
% (in one figure) for each drive
figure(3);
plot(time_stamp1,ds1,'--');
hold on;
plot(time_stamp1,Lat_dev1,'-');
title('Lateral Deviation and Smoothed Lateral Deviation in Velocity 1');
xlabel('Time (s)');
ylabel('Deviations (m)');
legend('Lateral Deviation','Smoothed Lateral Deviation');

figure(4);
plot(time_stamp2,ds2,'--');
hold on;
plot(time_stamp2,Lat_dev2,'-');
title('Lateral Deviation and Smoothed Lateral Deviation in Velocity 2');
xlabel('Time (s)');
ylabel('Deviations (m)');
legend('Lateral Deviation','Smoothed Lateral Deviation');

% Plot Velocity (pick out the begin and end data)
figure(5);
plot(time_stamp1(80:729),velocity1(80:729),':');
title('Velocity 1');
ylabel('Velocity (m/s)');
xlabel('Time (s)');

figure(8);
plot(time_stamp2(45:356),velocity2(45:356),'--');
title('Velocity 2');
ylabel('Velocity (m/s)');
xlabel('Time (s)');


% Corrected coordinates and original measured coordinates
% for each drive
figure(6);
plot(X_Corr1,Y_Corr1,'c');
hold on;
plot(X1,Y1,'r');
title('Corrected Coordinates and Original Measured Coordinates in Velocity 1');
xlabel('X (m)');
ylabel('Y (m)');
legend('Correct Coordinates','Original Measured Coordinates');

figure(7);
plot(X_Corr2,Y_Corr2,'c');
hold on;
plot(X2,Y2,'r');
title('Corrected Coordinates and Original Measured Coordinates in Velocity 2');
xlabel('X (m)');
ylabel('Y (m)');
legend('Correct Coordinates','Original Measured Coordinates');

