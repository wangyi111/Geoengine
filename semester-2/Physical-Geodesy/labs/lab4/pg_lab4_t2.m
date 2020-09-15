%% Pysical Geodesy lab4 T2
% author: Yi Wang
% last change: 27/06/2019
clear;
clc;
data = load('loisach.mat');
x = data.x;
y = data.y;
g = data.gr; % [mGal]
g0 = -98; % [mGal]
G = 6.67e-11;
dg = g-g0; % [mGal]
dx = 100;
dy = 100;
dxdy = dx*dy; % [m^2]
imax = length(x);
jmax = length(y);
total_g = 0;

for i = 1:imax
    for j = 1:jmax
        total_g = total_g + dg(j,i)*10^(-5) *dxdy;
    end
end

dM = 1/(4*pi*G)*total_g
