clear;
clc;
A=[9,-3,2,1,2;-3,2,1,8,2;2,1,-4,-4,1;1,8,-4,-4,1;2,2,1,1,10];
iterMax=100;
tol=1e-10;
A=jacobipq(A,iterMax,tol);
A
