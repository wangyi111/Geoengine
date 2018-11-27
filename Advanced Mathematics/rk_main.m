clc;
clear;
rk_ode=@(x,y)[y(2),-x*y(1)];
x0=0;
h=0.01;
xmax=6;
y0=[0.35502805388,0];
RungeKutta4(rk_ode,x0,h,xmax,y0);
title('R-K numerical integration for: y"+xy=0');