clear;
clc;

option=1;

switch option

%% T1
    case 1
data1=load('task1_sensor1.txt');
data2=load('task1_sensor2.txt');

[T1,sigma1] = allan(data1,100,length(data1));
[T2,sigma2] = allan(data2,150,length(data2));

figure();
loglog(T1,sigma1);
hold on;
loglog(T2,sigma2);
legend('data1','data2');

%% T2
    case 2
        data3=load('task2_accel.txt');
        dt=0.01;
        t=0:dt:10;
        N=length(data3);
        for i=3:N
            a_2(i-2)=(3*data3(i-1)-data3(i))/dt;
            a_1(i-1)=(data3(i-1)+data3(i))/dt;
            a_0(i)=(3*data3(i)-data3(i-1))/dt;
        end
        
        figure();
        plot(t(1:N-2),a_2);
        hold on;
        plot(t(1:N-2),a_1(1:N-2));
        hold on;
        plot(t(1:N-2),a_0(1:N-2));
        legend('a_2','a_1','a_0');
        
        figure();
        plot(t(1:N-2),a_2-a_1(1:N-2));
        hold on;
        plot(t(1:N-2),a_0(1:N-2)-a_1(1:N-2));
        hold on;
        plot(t(1:N-2),a_1(1:N-2));
        legend('a_2-a_1','a_0-a_1','a_1');        
        
        std_a_2_1=mean((a_2-a_1(1:N-2)-mean(a_2-a_1(1:N-2))).^2);
        std_a_0_1=mean((a_0(1:N-2)-a_1(1:N-2)-mean(a_0(1:N-2)-a_1(1:N-2))).^2);
        
        

end



function [T,sigma] = allan(omega,fs,pts)
[N,M] = size(omega); % figure out how big the output data set is
n = 2.^(0:floor(log2(N/2)))'; % determine largest bin size
maxN = n(end);
endLogInc = log10(maxN);
m = unique(ceil(logspace(0,endLogInc,pts)))'; % create log spaced vector average factor

t0 = 1/fs; % t0 = sample interval
T = m*t0; % T = length of time for each cluster
theta = cumsum(omega)/fs; % integration of samples over time to obtain output angle ?
sigma2 = zeros(length(T),M); % array of dimensions (cluster periods) X (#variables)
for i=1:length(m) % loop over the various cluster sizes
 for k=1:N-2*m(i) % implements the summation in the AV equation
 sigma2(i,:) = sigma2(i,:) + (theta(k+2*m(i),:) - 2*theta(k+m(i),:) + theta(k,:)).^2;
 end
end
sigma2 = sigma2./repmat((2*T.^2.*(N-2*m)),1,M);
sigma = sqrt(sigma2); 
end