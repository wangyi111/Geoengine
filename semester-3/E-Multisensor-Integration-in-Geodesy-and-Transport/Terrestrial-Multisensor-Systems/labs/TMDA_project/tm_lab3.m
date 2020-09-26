%% tm lab3
% author: yongyuandishen!
% 2/6/2020

%% calibration for Gyroscope
% k = 0.695342;
% k0 = 2.4805;
% dphi = k * (road_Gyro(:,2)-k0);
% dt = 100/1000;
% phi = data_gyro(:,2)*dt;
% plot(phi)
% data_gyro = ones(5369,2);
% data_gyro(:,1) = road_Gyro(6066:end,1);
% data_gyro(:,2) = phi;
% save('Gyroscope_cali_dangle','data_gyro');
% plot(road_Odo(:,2));

%% calibration for odometer
% k = ((218+218.5)/100)/(1054+1039); % [m]
% road_Odo(:,2) = road_Odo(:,2)/k;
% road_Odo(:,3) = road_Odo(:,3)/k;
% save('data_odo','road_Odo');
% figure
% plot(data_odo(:,2));
% hold on
% plot(data_odo(:,3));
% data_odo = road_Odo(6066:end,:);
% save('Odometer_cali_distance','data_odo');

%% calibration for GPS 
% data_gps = road_Gps(6066:end,:);
% j = 1;
% for i = 1:5369 
% if data_gps(i,1) ~= 0
% Gps_vald_data(j,:) = data_gps(i,:);
% j = j+1;
% end
% end
% [M,N] = size(Gps_vald_data);
% Gps_cali_data = zeros(M,N/2);
% Gps_cali_data(:,1) =Gps_vald_data(:,1);
% Gps_cali_data(:,2) =Gps_vald_data(:,3)+Gps_vald_data(:,4)/100000;
% Gps_cali_data(:,3) =Gps_vald_data(:,5)+Gps_vald_data(:,6)/100000;
% Gps_cali_data(:,4) =Gps_vald_data(:,7);
% save('Gps_cali_position','Gps_cali_data');


clc
clear all
close all

load 'Gps_cali_position'
load 'Gyroscope_cali_dangle'
load 'Odometer_cali_distance'
load 'OpticalSpeed_cali_distance.mat'

dt = 0.1;
dT = 1;
ref   = textread( 'reference.txt','%s');
ref   = reshape(ref,16,[]);
ref_t = convertCharsToStrings(ref(4,:)');
ref_X = str2num(cell2mat(ref(5,:)'));
ref_Y = str2num(cell2mat(ref(6,:)'));

%% calibration based on GPS_data
for i = 1:length(Gps_cali_data(:,1))
for j = 1:length(data_odo(:,1))
    if Gps_cali_data(i,4) == data_odo(j,1)||Gps_cali_data(i,4) == data_gyro(j,1)||Gps_cali_data(i,4) == distance_full_opticspeed(j,1)
        data_sum(i,1) = Gps_cali_data(i,2);
        data_sum(i,2) = Gps_cali_data(i,3);
        data_sum(i,3) = (data_gyro(j+1,2)-data_gyro(j,2))/dt;
        data_sum(i,4) = (data_odo(j,3)-data_odo(j,2))/1.72;
        data_sum(i,5) = (data_odo(j+1,3)+data_odo(j+1,2))/2-(data_odo(j,3)+data_odo(j,2))/2;
        data_sum(i,6) = (distance_full_opticspeed(j,2)*dT);
    end
end
end

data_sum(159,5) = 0;
kinematic_1 = data_sum(360:472,:);
kinematic_2 = data_sum(548:620,:);
Kalman_1 = random_model(kinematic_1);
Kalman_2 = random_model(kinematic_2);

straightline_1 = data_sum(1:72,:);
straightline_2 = data_sum(80:108,:);
Kalman_3 = straightline_model(straightline_1);
Kalman_4 = straightline_model(straightline_2);


