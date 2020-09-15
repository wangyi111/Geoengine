clear all; clc; close all;
% Purpose: Compare the Legendre Polynomial (m=0)difference between
% the result from left hand side of addition theorem 
% the result from right hand side of addition theorem
% at theta_P =90,theta_Q =0~90, degree l from 0~100  
% assume lamda_Q = lamda_P

lamda = linspace(-180,180,360);
theta_Q = linspace(0,90,90); % [deg]
theta_P = 90;
Phi_P = 0; % at equator

%% (left hand side)
% spherical distance
% lefthand side: non-normalized polynomial

Phi_PQ = 90 - theta_Q - Phi_P;
% syms t
% ts = cosd(Phi_PQ);
figure
subplot(2,1,1)
for l = 0:100
%      Pl = 1/(2^l*factorial(l))*diff((t^2-1).^l,l);
%      A_left(l+1,:) = vpa(subs(Pl,t,ts));     %Rodrigues method
     A_left(l+1,:) = Recursive(l,0,cosd(Phi_PQ));
     plot(theta_Q,A_left(l+1,:));
     hold on
end
title('left hand side')
ylabel('Pl(cos(phiPQ))')
subplot(2,1,2)
imagesc(A_left);
ylabel('l degree')
xlim([0 90])
xlabel('\theta [deg]')



%% (right hand side)

figure 
subplot(2,1,1)
for l =0:100
    inner = [];
    for m = 0:l
        Plm_q(m+1,:) = Recursive_norm(l,m,cosd(theta_Q)); % 
        Plm_p(m+1,:) = Plm_q(m+1,end);
    end 
    Plm_p_2D = meshgrid(Plm_p,(1:90))';
    A_right(l+1,:) = sum(Plm_p .* Plm_q,1)./ (2*l+1); %vertical sum
    plot(theta_Q,A_right(l+1,:));
    hold on
end
title('right hand side')
ylabel('Pl(cos(phiPQ))')
subplot(2,1,2)
imagesc(A_right);
ylabel('l degree')
xlim([0 90])
xlabel('\theta [deg]')



%% difference between left and right
figure
subplot(2,1,1)
A_diff = A_left - A_right;
for l = 0 : 100
    plot(theta_Q, A_diff(l+1,:));
    hold on
end
title('Verification of Addition theorem')
ylabel('differece of left and right hand equation')
subplot(2,1,2)
imagesc(A_diff);
xlabel('\theta [deg]')
ylabel('differece of left and right hand equation')
xlim([0 90])


