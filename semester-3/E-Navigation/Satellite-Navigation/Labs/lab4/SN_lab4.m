% clear;
% clc;
% file='INSA00DEU_R_20193391200_01H_01S_MO.rnx';
% 
% 
% [G, R, S, E, C, J, numEpoche, numSat,numSat_epoch]=readObs(file);


%% 1.b
% Sys={G;R;S;E;C;J};
% 
% for i=1:6
% b_num(i)=num_notempty(Sys{i});
% end
% 
% b_tnum=sum(b_num);
% % b_tnum=num_notempty(G)+num_notempty(S)+num_notempty(R)+num_notempty(E)+num_notempty(J)+num_notempty(C);
% figure();
% bar(b_num);
% title('numbers of satellites of each system');
% xlabel('G,R,S,E,C,J');
figure();
for i=1:6
plot(1:numEpoche,numSat_epoch(i,:));
hold on;
end
title('numbers of satellites of each system');
legend('G,R,S,E,C,J');

%% 1.c
figure();

subplot(1,2,1);
    plot(1:numEpoche,G{6}.S1C,'r');
    hold on;
    plot(1:numEpoche,G{6}.S2W,'g');
    hold on;
    
    plot(1:numEpoche,G{6}.S2X,'b');
    hold on;   
    
    plot(1:numEpoche,G{6}.S5X,'k');
    hold on;
    title('SN of GPS06');
    legend('S1C','S2W','S2X','S5X');

subplot(1,2,2);
    plot(1:numEpoche,R{22}.S1C,'r');
    hold on;
    plot(1:numEpoche,R{22}.S1P,'g');
    hold on;
    
    plot(1:numEpoche,R{22}.S2C,'b');
    hold on;   
    
    plot(1:numEpoche,R{22}.S2P,'k');
    hold on;
    title('SN of GLONASS22');
    legend('S1C','S1P','S2C','S2P');

%% 1.d
figure();

subplot(1,2,1);
    plot(1:numEpoche,G{6}.L1C,'r');
    hold on;
    plot(1:numEpoche,G{6}.L2W,'g');
    hold on;
    
    plot(1:numEpoche,G{6}.L2X,'b');
    hold on;   
    
    plot(1:numEpoche,G{6}.L5X,'k');
    hold on;
    title('Carrier Phase of GPS06');
    legend('L1C','L2W','L2X','L5X');

subplot(1,2,2);
    plot(1:numEpoche,R{22}.L1C,'r');
    hold on;
    plot(1:numEpoche,R{22}.L1P,'g');
    hold on;
    
    plot(1:numEpoche,R{22}.L2C,'b');
    hold on;   
    
    plot(1:numEpoche,R{22}.L2P,'k');
    hold on;
    title('Carrier Phase of GLONASS22');
    legend('L1C','L1P','L2C','L2P');

%% 1.e
% better use two more seperate frequencies
G_L1=1575.42e6;
G_L2=1227.60e6;
G_L5=1176.45e6;
R_G1_22=(1602+(-3)*9/16)*1e6;
R_G2_22=(1246+(-3)*7/16)*1e6;  % typo in document
R_G3=1202.025e6;
e_G06_2X5X=code_minus_carrier(G_L2,G{6}.L2X,G{6}.C2X,G_L5,G{6}.L5X,G{6}.C5X);
e_G06_2W5X=code_minus_carrier(G_L2,G{6}.L2W,G{6}.C2W,G_L5,G{6}.L5X,G{6}.C5X);
e_G06_1C5X=code_minus_carrier(G_L1,G{6}.L1C,G{6}.C1C,G_L5,G{6}.L5X,G{6}.C5X);
e_G06_1C2W=code_minus_carrier(G_L1,G{6}.L1C,G{6}.C1C,G_L2,G{6}.L2W,G{6}.C2W);
e_G06_1C2X=code_minus_carrier(G_L1,G{6}.L1C,G{6}.C1C,G_L2,G{6}.L2X,G{6}.C2X);


e_R22_C=code_minus_carrier(R_G1_22,R{22}.L1C,R{22}.C1C,R_G2_22,R{22}.L2C,R{22}.C2C);
e_R22_P=code_minus_carrier(R_G1_22,R{22}.L1P,R{22}.C1P,R_G2_22,R{22}.L2P,R{22}.C2P);
e_R22_CP=code_minus_carrier(R_G1_22,R{22}.L1C,R{22}.C1C,R_G2_22,R{22}.L2P,R{22}.C2P);
e_R22_PC=code_minus_carrier(R_G1_22,R{22}.L1P,R{22}.C1P,R_G2_22,R{22}.L2C,R{22}.C2C);


figure();
subplot(1,2,1);
plot(1:numEpoche,e_G06_2X5X,'r');
hold on;
plot(1:numEpoche,e_G06_2W5X,'g');
hold on;
plot(1:numEpoche,e_G06_1C5X,'b');
hold on;
plot(1:numEpoche,e_G06_1C2W,'k');
hold on;
plot(1:numEpoche,e_G06_1C2X,'y');
legend('e_G06_2X5X','e_G06_2W5X','e_G06_1C5X','e_G06_1C2W','e_G06_1C2X');
title('code-minus-carrier: GPS');
subplot(1,2,2);
plot(1:numEpoche,e_R22_C,'g');
hold on;
plot(1:numEpoche,e_R22_P,'b');
hold on;
plot(1:numEpoche,e_R22_CP,'r');
hold on;
plot(1:numEpoche,e_R22_PC,'k');
legend('e_R22_C','e_R22_P','e_R22_CP','e_R22_PC');
title('code-minus-carrier: GLONASS');


    
    

function y=num_notempty(x)

    y=length(x)-sum(cellfun('isempty',x));
end

function y=code_minus_carrier(f1,phi1,r1,f2,phi2,r2)
c=299792458;

phi_IF=(f1^2*phi1-f2^2*phi2)/(f1^2-f2^2);
r_IF=(f1^2*r1-f2^2*r2)/(f1^2-f2^2);
n1=f1^2/(f1^2-f2^2);
n2=-f2^2/(f1^2-f2^2);
lambda_IF=c/(n1*f1+n2*f2);
y=r_IF-phi_IF*lambda_IF;
end
