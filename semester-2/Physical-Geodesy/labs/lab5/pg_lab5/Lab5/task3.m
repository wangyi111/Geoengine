clear all; clc; close all;
%% Addition Theorem: if thetaP = thetaQ
theta = linspace(0,180,180);
figure
subplot(2,1,1)
for l = 0:100
    inner = [];
    for m = 0:l
        Plm(m+1,:) = Recursive_norm(l,m,cosd(theta));
    end 
    A_theta_same(l+1,:) = sum(Plm.*Plm,1)./ (2*l+1); %vertical sum
    plot(theta, A_theta_same(l+1,:));
    hold on
end
title('\theta p = \theta q right hand side')
xlim([0 180])
subplot(2,1,2)
imagesc(A_theta_same);
xlabel('\theta [deg]')
ylabel('l degree')
xlim([0 180])
