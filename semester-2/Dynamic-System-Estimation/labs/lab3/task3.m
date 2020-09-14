%% DSE_Lab3_T3

dt=1;
w0=0.2;
b=sqrt(2*2^0.5*w0^3);
% F=[0 1;0 0]
F=[0 1;-w0^2 -w0*2^0.5];
GWGT=[0 0;0 b^2];
A=[-F GWGT;zeros(2,2) F']*dt
B=expm(A)

phi=B((3:4),(3:4))'
Q=phi*B((1:2),(3:4))