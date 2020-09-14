% Kinematic Measurement Systems Lab3
% Auther: Yi Wang
% Last change: 24/05/2019

clear;
clc;

%set(0,'defaultfigurecolor','w')
%% load data  Q00: delete how many data previously?
% measuring data
data1=xlsread('group1_1.xlsx');
data2=xlsread('group1_2.xlsx');

% Q0: coordinates of the tachymeter?
X_s=0;
Y_s=0;
Ori=0;
% X_s = 4.71093; % m
% Y_s = 2.25322; % m
% Ori = 2.10441; % rad


% time   ms
time_stamp1=data1(:,1)/1000;
time_stamp2=data2(:,1)/1000;

% horizontal angle  rad
Hz1=data1(:,2)*pi/200;
Hz2=data2(:,2)*pi/200;

% vertical angle   rad
V1=data1(:,3)*pi/200;
V2=data2(:,3)*pi/200;

% slope distance   m
slope1=data1(:,4);
slope2=data2(:,4);

% Y   m
Y1=data1(:,5);
Y2=data2(:,5);

% X   m
X1=data1(:,6);
X2=data2(:,6);

% ds   m
ds1=data1(:,7);
ds2=data2(:,7);

%% main process
% smoothing of lateral deviation
lat_dev1=movmean(ds1,5);
lat_dev2=movmean(ds2,5);
% delta lateral deviation
delta_lat_dev1=max(lat_dev1)-min(lat_dev1); 
delta_lat_dev2=max(lat_dev2)-min(lat_dev2); 
% mean velocity
n1=length(ds1)-1;
n2=length(ds2)-1;
d_delta1=zeros(n1,1);
d_delta2=zeros(n2,1);
dt1=zeros(n1,1);
dt2=zeros(n2,1);
velocity1=zeros(n1,1);
velocity2=zeros(n2,1);
for i=1:n1
    d_delta1(i+1)=sqrt((X1(i+1)-X1(i))^2+(Y1(i+1)-Y1(i))^2);
    dt1(i+1)=time_stamp1(i+1)-time_stamp1(i);
    velocity1(i+1)=d_delta1(i+1)/dt1(i+1);
end
mean_v1=mean(velocity1,'omitnan');
for i=1:n2
    d_delta2(i+1) = sqrt((X2(i+1)-X2(i))^2+(Y2(i+1)-Y2(i))^2);
    dt2(i+1) = time_stamp2(i+1)-time_stamp2(i);
    velocity2(i+1) = d_delta2(i+1)/dt2(i+1);
end
mean_v2=mean(velocity2,'omitnan');
% synchronization error
delta_t1=delta_lat_dev1/mean_v1;
delta_t2=delta_lat_dev2/mean_v2;
% real horizontal distane
s_hz1=slope1.*sin(V1);
s_hz2=slope2.*sin(V2);
s_real1=zeros(n1,1);
s_real2=zeros(n2,1);
for i=1:n1
    s_real1(i+1)=s_hz1(i+1)+delta_t1/(time_stamp1(i+1)-time_stamp1(i))*(s_hz1(i)-s_hz1(i+1));
end
for i=1:n2
    s_real2(i+1)=s_hz2(i+1)+delta_t2/(time_stamp2(i+1)-time_stamp2(i))*(s_hz2(i)-s_hz2(i+1));
end
% corrected coordinates
X_Corr1 = X_s + s_real1.*cos(Ori+Hz1);
Y_Corr1 = Y_s + s_real1.*sin(Ori+Hz1);

X_Corr2 = X_s + s_real2.*cos(Ori+Hz2);
Y_Corr2 = Y_s + s_real2.*sin(Ori+Hz2);
X_Corr1(1,:)=[];
Y_Corr1(1,:)=[];
X_Corr2(1,:)=[];
Y_Corr2(1,:)=[];

%% plot data
% XY coordinates of the prism
figure(1);
subplot(1,2,1);
plot(X1,Y1);
title('XY coordinates of the prism with v1');
xlabel('X(m)');
ylabel('Y(m)');
subplot(1,2,2);
plot(X2,Y2);
title('XY coordinates of the prism with v2');
xlabel('X(m)');
ylabel('Y(m)');
% lateral deviation and smoothed lateral deviation
figure(2);
subplot(1,2,1);
plot(time_stamp1,ds1,'r-');
hold on;
plot(time_stamp1,lat_dev1,'g-');
title('Lateral Deviation and Smoothed Lateral Deviation with v1');
xlabel('Time(s)');
ylabel('Lateral Deviation(m)');
legend('Lateral Deviation','Smoothed Lateral Deviation');
subplot(1,2,2);
plot(time_stamp2,ds2,'r-');
hold on;
plot(time_stamp2,lat_dev2,'g-');
title('Lateral Deviation and Smoothed Lateral Deviation with v2');
xlabel('Time(s)');
ylabel('Lateral Deviation(m)');
legend('Lateral Deviation','Smoothed Lateral Deviation');
% velocity
figure(3);
subplot(1,2,1);
plot(time_stamp1,velocity1,'-');
title('Velocity 1');
ylabel('Velocity(m/s)');
xlabel('Time(s)');
subplot(1,2,2);
plot(time_stamp2,velocity2,'-');
title('Velocity 2');
ylabel('Velocity(m/s)');
xlabel('Time(s)');
% corrected coordinates and original measured coordinates
figure(4);
subplot(1,2,1);
plot(X_Corr1,Y_Corr1,'g');
hold on;
plot(X1,Y1,'r');
title('Corrected Coordinates and Original Measured Coordinates with v1');
xlabel('X(m)');
ylabel('Y(m)');
legend('Correct Coordinates','Original Measured Coordinates');
subplot(1,2,2);
plot(X_Corr2,Y_Corr2,'g');
hold on;
plot(X2,Y2,'r');
title('Corrected Coordinates and Original Measured Coordinates with v2');
xlabel('X(m)');
ylabel('Y(m)');
legend('Correct Coordinates','Original Measured Coordinates');