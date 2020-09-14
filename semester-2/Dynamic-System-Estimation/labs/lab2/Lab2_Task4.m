%% DSE_Lab2_T4

omega = 0.03;
f = 0.25;
deltaT = 1;


F = [0,1;-omega.^2,-2*f*omega];
phi=expm(F*deltaT);
x = zeros(2,100001);

for i = 1:100000
    w = normrnd(0,1);
    x(:,i+1) = phi*x(:,i) + [0;w];
end
figure(1);
t=0:100000;
plot(t,x(1,:));
hold on;
figure(2);
tau = -1000:1000;
% sigmax1=sum((x(1,:)-mean(x)).^2)/length(x(1,:));

sigma=var(x(1,:));
beta=omega*sqrt(1-f^2);
COVx1x1=sigma*exp(-f*omega*abs(tau)).*(cos(beta*abs(tau))+(f*omega/beta)*sin(beta*abs(tau)));
plot(tau,xcov(x(1,:),x(1,:),1000,'biased'),tau,COVx1x1);
