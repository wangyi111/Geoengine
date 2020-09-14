%% DSE_lab6_t1

Sigma0=100;
Sigma_w=4;
Sigma_r=1;

dt=1;
Phi=1;
Q=Sigma_w*dt;
P1=Sigma0;
P2=Sigma0;
R=Sigma_r;
for i=1:200
  H1=0.5;
  H2=cos(1+i/90);
  % prediction
  P1=Phi*P1*Phi'+Q;
  K1=P1*H1'*(H1*P1*H1'+R)^(-1);
  P1=(1-K1*H1)*P1;
  P_1(i)=P1;
  
  
  P2=Phi*P2*Phi'+Q;
  K2=P2*H2'*(H2*P2*H2'+R)^(-1);
  P2=(1-K2*H2)*P2;
  P_2(i)=P2;
end

t=1:200;
figure;
subplot(2,1,1);
plot(t,P_1);
subplot(2,1,2);
plot(t,P_2);
