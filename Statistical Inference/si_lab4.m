clear;
clc;
data=importdata('lab4-data.txt');
Data=data.data;
x1=Data(:,1);
y1=Data(:,2);
x2=Data(:,3);
y2=Data(:,4);
x3=Data(:,5);
y3=Data(:,6);
x4=Data(:,7);
y4=Data(:,8);

A1_1=[ones(11,1),x1];
A1_2=[A1_1,x1.^2];

N1_1=A1_1'*A1_1;
N1_2=A1_2'*A1_2;

X1_1=N1_1^(-1)*A1_1'*y1;
X1_2=N1_2^(-1)*A1_2'*y1;
Y1_1=A1_1*X1_1;
Y1_2=A1_2*X1_2;
e1_1=Y1_1-y1;
e1_2=Y1_2-y2;
ee1_1=e1_1'*e1_1;
ee1_2=e1_2'*e1_2;
r1_1=11-2;
r1_2=11-3;
eer1_1=ee1_1/r1_1;
eer1_2=ee1_2/r1_2;

[A1,N1,invN1,X1,ee1,eer1]=regress(x1,y1,2);


function [A,N,invN,X_hat,ee,eer]=regress(x,y,n)

m=length(x);
if n==1
  A=[ones(m,1),x];
  r=m-2;
else
  if n==2
      A=[ones(m,1),x,x.^2];
      r=m-3;
  end
end

N=A'*A;
invN=N^(-1);
X_hat=N^(-1)*A'*y;
Y_hat=A*X_hat;
e=y-Y_hat;
ee=e'*e;
eer=ee/r;
end
