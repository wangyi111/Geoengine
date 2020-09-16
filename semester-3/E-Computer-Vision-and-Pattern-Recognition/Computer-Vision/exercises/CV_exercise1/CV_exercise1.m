%% computer vision exercise1
% image alignment

clear;
clc;

fig1=imread('Gebaeude_0004_half.jpg');
fig2=imread('Gebaeude_0005_half.jpg');
% fig1=imread('GEOENGINE_2019_1.jpg');
% fig2=imread('GEOENGINE_2019_2.jpg');





imshow(fig1);
[xi1,yi1]=getline;

imshow(fig2);
[xi2,yi2]=getline;

close all;


%% transform matrix
NPts=length(xi1);

x1=[xi1,yi1,ones(NPts,1)]';
x2=[xi2,yi2,ones(NPts,1)]';

A=zeros(2*NPts,9);
O=[0 0 0];
for n=1:NPts
    X=x1(:,n)';
    x=x2(1,n); y=x2(2,n); w=x2(3,n);
    A(2*n-1,:)=[O -w*X y*X];
    A(2*n,:)=[w*X O -x*X];
end

[U,D,V]=svd(A,0);
H=reshape(V(:,9),3,3)';
x_calc=H*x1;
x_calc(1,:) = x_calc(1,:)./x_calc(3,:);
x_calc(2,:) = x_calc(2,:)./x_calc(3,:);
x_calc(3,:) = [];
% Calculate residuals
res_x = xi2' - x_calc(1,:);
res_y = yi2' - x_calc(2,:);
res=[res_x;res_y];

%% image mapping

[width,height,numbands] = size(fig1);
% Map of pixel coordinates 
[xi,yi] = meshgrid(1:height,1:width);
% Homogenous coordinates and Normalization
TransPoints = [xi(:) yi(:) ones(length(xi(:)),1)]';
Pix_points = H* TransPoints;
Pix_points(1,:) = Pix_points(1,:)./Pix_points(3,:);
Pix_points(2,:) = Pix_points(2,:)./Pix_points(3,:);
Pix_points(3,:) = [];
xi = reshape(Pix_points(1,:),width,height);
yi = reshape(Pix_points(2,:),width,height);

% RGB to gray value
fig1_grey = rgb2gray(fig1);                            
fig1_grey = double(fig1_grey); 
fig2_grey = rgb2gray(fig2);                              
newfig = interp2(double(fig2_grey),xi,yi,'bicubic',0);



figure(1);
subplot(1,2,1);
imshow(fig1);
hold on;
plot(xi1,yi1,'ro');
title('5 identical points in fig1');

subplot(1,2,2);
imshow(fig2);
hold on;
plot(xi2,yi2,'ro');
title('5 identical points in fig2');





figure(2);
imshow(uint8(newfig));
title('fig1 in the geometry of fig2');

zero = find(newfig==0);
pano = (fig1_grey+newfig)./2;
pano(zero) = fig1_grey(zero);

figure(3);
imshow(uint8(pano));
title('Panorama Image');



