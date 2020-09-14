%% Dynamic System Estimation lab2_T2
%12/5/2019
%task 2
clear;
clc;
%% load data and initial values
x_total=zeros(20,100);
W=load('random02.txt');
dt=1;
F=[0,1;0,0];
Phi=expm(F*dt);
Phi   
%% compute the stochastic process for 100 times with 20 steps each
N=20;
for j=1:100
w=W(:,j);
x=[0 0]';
x_solution=zeros(2,N);
x_solution(:,1)=x;
for  i=1:20
    
    x=Phi*x+[0;w(i)];
    x_solution(:,i)=x;
    
end
x_total(:,j)=x_solution(1,:);


plot(x_solution(1,:)); hold on;

end


figure(2);
%% compute the mean value and its variance
M=zeros(20:1);
S=zeros(20:1);
for i=1:20
M(i)=mean(x_total(i,:));
% S(i)=var(x_total(i,:));
end
S=var(x_total');
plot(M);hold on;
plot(S);

legend('M','S');



