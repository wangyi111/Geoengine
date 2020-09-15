close all;
clear;
clc;

% Possible Improvements: changing cells to 3 dimensional auto-fit matrixes would evidently increase the speed

l=10;
for i=0:l    
prf{i+1}=RF_P(l,i);
prc{i+1}=RC_P(l,i);
end

lambda=-180:1:180;
yrf_z=zeros(181,361);
yrf_t=zeros(181,361);
yrf_s=zeros(181,361);
lambda1=lambda/180*pi;
for i=0:180
    for j=-180:180
yrf_z(i+1,j+181)=prf{1}(i+1)*cos(0*lambda1(j+181));
yrf_t(i+1,j+181)=prf{5}(i+1)*cos(5*lambda1(j+181));
yrf_s(i+1,j+181)=prf{10}(i+1)*cos(10*lambda1(j+181));
    end
end


theta=0:1:180;

figure(1);
for i=0:l
plot(theta,prf{i+1});
hold on;
end
title('Rodrigues-Ferrers');

figure(2);
for i=0:l
plot(theta,prc{i+1});
hold on;
end
title('Recursive');


figure(3);
% meshgrid(lambda,phi);
subplot(3,2,1);
plot(theta,prc{1});
subplot(3,2,2);
% plot(yrf_z);
imagesc(lambda,theta,yrf_z)
subplot(3,2,3);
plot(theta,prc{6});
subplot(3,2,4);
% plot(yrf_t);
imagesc(lambda,theta,yrf_t)
subplot(3,2,5);
plot(theta,prc{11});
subplot(3,2,6);
% plot(yrf_s);
imagesc(lambda,theta,yrf_s)








disp('vertig');








function y=RF_P(l,m)
theta=0:1:180;
t=cos(theta/180*pi);
n=length(t);

syms f1(x)
f1(x)=1/(2^l*factorial(l))*diff((x^2-1)^l,l);

syms f2(x)
f2(x)=(1-x^2)^(m/2)*diff(f1(x),m);

if m==0
    y=double(sqrt(2*l+1)*f2(t));
else
    y=double(sqrt(2*(2*l+1)*(factorial(l-m)/factorial(l+m)))*f2(t));
end

end


function y=RC_P(l,m)
theta=0:1:180;
t=cos(theta/180*pi);
n=length(t);

if l<m
    y=0;
elseif l==0&&m==0
    y=ones(1,n);

elseif l==1&&m==1
    y=sqrt(3*(1-t.^2));

elseif l==m
    y=sqrt((2*l+1)/(2*l))*sqrt(1-t.^2).*RC_P(l-1,l-1);
elseif l~=m
    y=sqrt((2*l+1)/((l+m)*(l-m)))*(sqrt((2*l-1))*t.*RC_P(l-1,m)-sqrt((l-1+m)*(l-1-m)/(2*l-3)).*RC_P(l-2,m));
end
end
