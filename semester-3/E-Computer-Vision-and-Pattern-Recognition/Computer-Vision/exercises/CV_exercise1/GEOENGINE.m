% Compuer Vision Exercise 1: Projective Transformation
% Image alignment by estimation of a homography
% Name: WANG Zhenqiao
% Student ID: 3371590
clc
clear
% Read image pair and measure 5 homologous points
GEOENGINE_2019_1 = imread('GEOENGINE_2019_1.jpg');
GEOENGINE_2019_2 = imread('GEOENGINE_2019_2.jpg');
% show images to pick 5 points
imshow(GEOENGINE_2019_1);
title('GEOENGINE_2019_1','Interpreter','none');
set(gcf,'outerposition',get(0,'screensize'));
[xi,yi] = getline();
imshow(GEOENGINE_2019_2);
title('GEOENGINE_2019_2','Interpreter','none');
set(gcf,'outerposition',get(0,'screensize')); 
[xip,yip] = getline();
close all;

% Generate homogenous coordinates
n = length(xi);
x = [xi yi ones(n,1)]';
xp = [xip yip ones(n,1)]';

% Calculate the projective transformation              
o = zeros(1,3);
wp = xp(3,:);
A = zeros(2*n,9);
for i = 1:n
    wip = wp(i);        
    A(2*i-1:2*i,:) = [o -wip*x(:,i)' yip(i)*x(:,i)';
                      wip*x(:,i)' o -xip(i)*x(:,i)'];
end
% Single value decomposition
[U, D, V] = svd(A,0);
H = reshape(V(:,9),3,3);
% Transform
x_test = H'*x;
x_test(1,:) = x_test(1,:)./x_test(3,:);
x_test(2,:) = x_test(2,:)./x_test(3,:);
x_test(3,:) = [];
% Calculate residuals
res_x = xip - x_test(1,:)';
res_y = yip - x_test(2,:)';

% Projective transformation
[r,c,n] = size(GEOENGINE_2019_1);
% Matrix of pixel coordinates 
[X,Y] = meshgrid(1:c,1:r);
% Initial matrix of pixel coordinates and generate homogenous coordinates
Image1 = [X(:) Y(:) ones(length(X(:)),1)]';
Image2 = H'* Image1;
Image2(1,:) = Image2(1,:)./Image2(3,:);
Image2(2,:) = Image2(2,:)./Image2(3,:);
Image2(3,:) = [];
X = reshape(Image2(1,:),r,c);
Y = reshape(Image2(2,:),r,c);

% RGB to gray value
GEOENGINE_2019_1_grey = rgb2gray(GEOENGINE_2019_1);                            
GEOENGINE_2019_1_grey = double(GEOENGINE_2019_1_grey); 
GEOENGINE_2019_2_grey = rgb2gray(GEOENGINE_2019_2);                              
newGEOENGINE = interp2(double(GEOENGINE_2019_2_grey),X,Y,'bicubic',0);

figure(1)
imshow(GEOENGINE_2019_1);
hold on
plot(xi,yi,'ro');
title('5 identical points');

figure(2)
imshow(uint8(newGEOENGINE));
title('GEOENGINE_2019_1 in the geometry of GEOENGINE_2019_2','Interpreter','none');

zero = find(newGEOENGINE==0);
pano = (GEOENGINE_2019_1_grey+newGEOENGINE)./2;
pano(zero) = GEOENGINE_2019_1_grey(zero);

figure(3)
imshow(uint8(pano));
title('Panorama Image of GEOENGINE');