%% DSE_Lab2_T1

close all
clear all
clc
t=1:100;
dt=1;
x0=0;
%% Define beta(0,1) and transition function phi
beta0 = 0.1;
beta1=input('Input a number between(0,1) as beta = ')
% transition function
phi0=exp(-beta0*dt);
phi1=exp(-beta1*dt);

solution=zeros(30,100);

%% realization
for j=1:30
    % generate random number
    % how to control that every time running get the same random value???
%    rng(0);
    W=normrnd(0,1,1,100);
    % initialize temp variable
    xi_1=x0;
    xi_2=x0;
    x_temp1=zeros(1,100);
    x_temp2=zeros(1,100);
    
    %% time steps
    for i=0:99
        x_1(j,i+1)=phi0*xi_1+W(i+1);
        x_2(j,i+1)=phi1*xi_2+W(i+1);
        
        x_temp1(i+1)=x_1(j,i+1);
        x_temp2(i+1)=x_2(j,i+1);
        
        xi_1=x_1(j,i+1);
        xi_2=x_2(j,i+1);
        
        solution1(j,i+1)=xi_1;
        solution2(j,i+1)=xi_2;
        
        % mean and varience
        miu_1(j,i+1)=  mean(x_temp1(1:i+1));
        vari_1(j,i+1)= var(x_temp1(1:i+1));
        
        miu_2(j,i+1)=  mean(x_temp2(1:i+1));
        vari_2(j,i+1)= var(x_temp2(1:i+1));
    end
    
    
    
    
%     
%     % plot result
%     figure(ceil(j/5))
%     subplot(2,5,(mod(j-1,5)+1))
%     hold on
%     plot(t,x_1(j,:));
%     plot(t,x_2(j,:));
%     plot(t,W,'.g');
%     beta2=['beta =',num2str(beta1)];
%     legend('beta=0.1',beta2,' radom number')
%     title ('simulations of 1st order GM Process with different beta')
%     hold off
%     
%     subplot(2,5,(5+mod(j-1,5)+1))
%     hold on
%     plot(t,vari_1(j,:));
%     plot(t,vari_2(j,:));
%     legend('beta=0.1',beta2);
%     title ('Varience for each time step ')
%     hold off
    
end

figure(1);
for i=1:30
    plot(t,x_1(i,:));
    hold on;
end

figure(2);
for i=1:30
    plot(t,x_2(i,:));
    hold on;
end






x1_var=zeros(100,1);
for i=1:100
    x1_var(i)=var(x_1(:,i));
end
figure(3);
plot(t,x1_var);

x2_var=zeros(100,1);
for i=1:100
    x2_var(i)=var(x_2(:,i));
end
figure(4);
plot(t,x2_var);

