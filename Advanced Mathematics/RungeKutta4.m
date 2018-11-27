function RungeKutta4(fxy,x0,h,xmax,y0)
% RungeKutta4(fxy,x0,h,xmax,y0)
% fxy: a function handle with the form fxy=@(x,y)...
% x0: initial value x
% h: stepwidth
% xmax: the maximum of x
% y0: initial value y ,can be scalar or vector depending on fxy
% author: Yi Wang
% Last chage:11/26/2018

if class(fxy)~='function_handle'
    err('incorrect fucntion type! ');
else
    if length(x0)~=1 || length(h)~=1 || length(xmax)~=1
        err('incorrect dimension for x0,h or xmax');
    end
end
% Question: how to compare the dimension of fxy and y0
xi=x0;
yi=y0;
i=0;
size=xmax/h;
x=zeros(size,1);
y=zeros(size,1);
x(1)=xi;
y(1)=yi(1);
while xi<xmax    
    k1=fxy(xi,yi);
    k2=fxy(xi+0.5*h,yi+0.5*h*k1);
    k3=fxy(xi+0.5*h,yi+0.5*h*k2);
    k4=fxy(xi+h,yi+h*k3);
    yip=yi+1/6*h*(k1+2*k2+2*k3+k4);    
    x(i+1)=xi+h;
    y(i+1)=yip(1);    
    i=i+1;
    xi=xi+h;
    yi=yip;
end

plot(x,y);    
    
