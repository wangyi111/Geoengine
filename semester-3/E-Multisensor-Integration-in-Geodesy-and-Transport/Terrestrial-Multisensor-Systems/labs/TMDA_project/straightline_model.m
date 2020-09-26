function [y_hat] = straightline_model(data)
dt = 1;
x = data(:,1);
y = data(:,2);
l = data';

%% cofactor matrix of observations
sigma_x = 0.7;     %[m]
sigma_y = 0.7;
sigma_d_phi_Gyro = 2*pi/180;   %% missing data for gyro
sigma_d_phi_odo = 3*pi/180;    
sigma_ds_odo = 0.1;
sigma_ds_opto = 0.1;
Q_l_l = diag([sigma_x,sigma_y,sigma_d_phi_Gyro,sigma_d_phi_odo,sigma_ds_odo,sigma_ds_opto].^2);

%% state vector
y_hat=zeros(5,length(x));
y_hat(:,1) = [x(1);y(1);atan2(y(1),x(1));0;0];
y_hat(:,2) = [x(2);y(2);atan2(y(2),x(2));0;0];

y_bar = [x(1);y(1);atan2(y(1),x(1));0;0];

Q_yhat_yhat = diag([sigma_x,  sigma_y, sigma_d_phi_Gyro, sigma_ds_odo, sigma_d_phi_odo].^2);

%% definition of disturbance
% white noise generating
a_dist = 1*randn(1,length(x));
v_dist = 1*randn(1,length(x));
w = [a_dist;v_dist];

for k= 2:length(x)
      Q_ww = diag([a_dist(k-1),v_dist(k-1)]);
      
      T_sl = [1, 0, -y_bar(4)*dt*sin(y_hat(3,k-1)+y_bar(5)), dt*cos(y_hat(3,k-1)+y_bar(5)), -y_bar(4)*dt*sin(y_hat(3,k-1)+y_bar(5));
              0, 1, y_bar(4)*dt*cos(y_hat(3,k-1)+y_bar(5)), dt*sin(y_hat(3,k-1)+y_bar(5)), y_bar(4)*dt*cos(y_hat(3,k-1)+y_bar(5));
              0, 0, 1, 0, 1;
              0, 0, 0, 1, 0;
              0, 0, 0, 0, 1];    

    % Disturbances 5*2
    S_sl = [0.5*(dt^2)*cos(y_hat(3,k-1)+y_bar(5)), -(dt^2)*y_bar(4)*sin(y_hat(3,k-1)+y_bar(5));
            0.5*(dt^2)*sin(y_hat(3,k-1)+y_bar(5)), (dt^2)*y_bar(4)*cos(y_hat(3,k-1)+y_bar(5));
            0,                                         dt;
            dt,                                        0;
            0,                                         dt];    
    % covariance matrix of predicted state vector
    
    Q_ybar_ybar = T_sl * Q_yhat_yhat * T_sl' + S_sl * Q_ww * S_sl';
    
    % Innovation 6*5
    A_sl = [1, 0, 0, 0, 0; 
            0, 1, 0, 0, 0; 
            0, 0, 0, 0, 1; 
            0, 0, 0, 0, 1;
            0, 0, 0, dt, 0; 
            0, 0, 0, dt, 0]; 

    % predicted state vector 5*1
%     y_bar = T_sl*y_hat(:,k-1) + S_sl * w(:,k-1); 
    y_bar(1) = y_hat(1,k-1)+y_hat(4,k-1)*dt*cos(y_hat(3,k-1)+y_hat(5,k-1));
    y_bar(2) = y_hat(2,k-1)+y_hat(4,k-1)*dt*cos(y_hat(3,k-1)+y_hat(5,k-1));
    y_bar(3) = y_hat(3,k-1)+y_hat(5,k-1);
    y_bar(4) = y_hat(4,k-1);
    y_bar(5) = y_hat(5,k-1);
    % predicted measurement 6*1
    l_bar = A_sl * y_bar;
    % innovation vector 6*n
    d = l(:,k) - l_bar;

    % covariance matrix of predicted measurement 6*6
    Q_lbar_lbar = A_sl * Q_ybar_ybar * A_sl';
    % covariance matrix of innovation vector 6*6
    Q_d_d = Q_l_l + Q_lbar_lbar;

    % Kalman Gain 5*6
    K = Q_ybar_ybar * A_sl' *   inv(Q_d_d);
    % updated state vector 5*1
    y_hat(:,k) = y_bar + K * d;
    % covariance matrix of updated state vector
    Q_yhat_yhat = Q_ybar_ybar - K * Q_d_d * K';

    % y_hat and Q_yhat_yhat as input for next epoch
end

%% display
figure
plot(y_hat(1,:),y_hat(2,:),'*-g');
hold on;
plot(data(:,1),data(:,2),'r')
grid on
legend('Kalman result','Gps');
title('Kalman filter Result of Straight Line Model')
xlabel('x');
ylabel('y');

end
