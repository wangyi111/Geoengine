function [y_hat] = random_model(data)
dt = 1;
x = data(:,1);
numCol = length(x);
vx = data(2:numCol,1) - data(1:numCol-1,1);
vy = data(2:numCol,2) - data(1:numCol-1,2);
l = zeros(6,length(x));  
l(1:2,:) = data(:,1:2)';

%% cofactor matrix of observations
sigma_x = 0.7;     %[m]
sigma_y = 0.7;
sigma_d_phi_Gyro = 2*pi/180;   %% missing data for gyro
sigma_d_phi_odo = 3*pi/180;    
sigma_ds_odo = 0.1;
sigma_ds_opto = 0.1;
Q_l_l = diag([sigma_x,sigma_y,sigma_d_phi_Gyro,sigma_d_phi_odo,sigma_ds_odo,sigma_ds_opto].^2);
%% state vector
y_hat=zeros(4,length(x));
y_hat(1,:) = l(1,:);
y_hat(2,:) = l(2,:);
y_hat(3,:) = [0,vx'];
y_hat(4,:) = [0,vy'];
y_hat(3,1) = y_hat(3,2);
y_hat(4,1) = y_hat(4,2);
Q_yhat_yhat = diag([sigma_x  sigma_y sigma_ds_odo sigma_ds_odo].^2);
%% definition of disturbance
% white noise generating
a_dist = 1*randn(1,length(x));
v_dist = 1*randn(1,length(x));
w = [a_dist;a_dist;v_dist;v_dist];
Q_w_w = 0.01^2;
sigma_0_2 = 1;
% define T
    T = [1 0 dt 0;
       0 1 0 dt;
       0 0 1 0;
       0 0 0 1 ];
for n = 3:length(x)
   % rotation angel at k+1 point
    phi_k1 = atan( ((y_hat(2,n)-y_hat(2,n-1)) / (y_hat(1,n)-y_hat(1,n-1)))); 
   % Disturbances
    S = [0.5*(dt^2)*cos(phi_k1);
    0.5*(dt^2)*sin(phi_k1);
    dt*cos(phi_k1);
    dt*sin(phi_k1)];
   % Covariance Matrix
    Q_ybar_ybar = T*Q_yhat_yhat*T'+S*Q_w_w*S';  
   % Predicted state vector
    y_bar = T * y_hat(:,n-1);% + S .* w(:,n-1);
    phi_k1bar = atan( (y_bar(2)-y_hat(2,n-1)) / (y_bar(1)-y_hat(1,n-1)));
    s_bar = sqrt( (y_bar(2)-y_hat(2,n-1))^2 + (y_bar(1)-y_hat(1,n-1))^2 );  
   % AA    
    A = zeros(6,4);
    A(1,1) = 1;
    A(2,2) = 1;
   % Predicted measurement
    l_bar = A * y_bar;
   % Innvation vector
    d = l(:,n) - l_bar;
    Q_lbar_lbar = A*Q_ybar_ybar*A';
    C_l_l = sigma_0_2*Q_l_l;
    Q_d_d = Q_l_l + Q_lbar_lbar;
    K = Q_ybar_ybar * A' * inv(Q_d_d);
   % Updated state vector
    y_hat(:,n) = y_bar + K*d;
    Q_yhat_yhat = Q_ybar_ybar-K*Q_d_d*K';
end
%% display
figure
plot(y_hat(1,:),y_hat(2,:),'*-g');
hold on;
plot(data(:,1),data(:,2),'r')
grid on
legend('Kalman result','Gps');
title('Kalman filter Result of Random Model')
xlabel('x');
ylabel('y');
end