% Compuer Vision Exercise 1: Projective Transformation
% Image alignment by estimation of a homography
% Name: WANG Zhenqiao
% Student ID: 3371590
clc
clear
% Read image pair and measure 5 homologous points
Gebaeude4 = imread('Gebaeude_0004_half.jpg');
Gebaeude5 = imread('Gebaeude_0005_half.jpg');
% show images to pick 5 points
imshow(Gebaeude4);
title('Gebaeude4');
set(gcf,'outerposition',get(0,'screensize'));
[xi,yi] = getline();
imshow(Gebaeude5);
title('Gebaeude5');
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
[r,c,n] = size(Gebaeude4);
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
Gebaeude4_grey = rgb2gray(Gebaeude4);                            
Gebaeude4_grey = double(Gebaeude4_grey); 
Gebaeude5_grey = rgb2gray(Gebaeude5);                              
newGebaeude = interp2(double(Gebaeude5_grey),X,Y,'bicubic',0);

figure(1)
imshow(Gebaeude4);
hold on
plot(xi,yi,'ro');
title('5 identical points');

figure(2)
imshow(uint8(newGebaeude));
title('Gebaeude4 in the geometry of Gebaeude5');

zero = find(newGebaeude==0);
pano = (Gebaeude4_grey+newGebaeude)./2;
pano(zero) = Gebaeude4_grey(zero);

figure(3)
imshow(uint8(pano));
title('Panorama Image of Gebaeude');