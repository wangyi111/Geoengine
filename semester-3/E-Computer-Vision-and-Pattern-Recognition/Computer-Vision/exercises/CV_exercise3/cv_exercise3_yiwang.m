%% Computer Vision Exercise 3
% Epipolar Image
% author: yiwang
% 10/01/2020
clear;
clc;
filepath_ori={'20774.ori','20775.ori'};
Para=read_ori(filepath_ori);
K1=str2double(Para(1).CameraMatrix);
K2=str2double(Para(2).CameraMatrix);
R1=str2double(Para(1).RotationMatrix);
R2=str2double(Para(2).RotationMatrix);
X1=(str2double(Para(1).TranslationVector))';
X2=(str2double(Para(2).TranslationVector))';
b=-R2*(X2-X1);
B=[0,-b(3),b(2);
   b(3),0,-b(1);
   -b(2),b(1),0];
% fundemental matrix
F=(inv(K2))'*B*(R2*R1')*inv(K1);


figure();
im1=imread('R0020774.jpg');
imshow(im1);
hold on;
[x,y]=getline();
plot(x,y,'ro');


figure();
im2=imread('R0020775.jpg');
imshow(im2);
hold on;
[m,n]=size(im2);
for i=1:length(x)
left_P=[x(i);y(i);1];
right_line = F*left_P;
right_epipolar_x = 1:2*m;
% Using the eqn of line: ax+by+c=0; y = (-c-ax)/b
right_epipolar_y = (-right_line(3)-right_line(1)*right_epipolar_x)/right_line(2);

plot(right_epipolar_x, right_epipolar_y, 'r');
hold on;

end





% read ori file
function [parameter]=read_ori(filepath)

len = length(filepath);
Para(len) = struct('Image_ID',0,'FocalLength',0,'PixelSize',0,'SensorSize',0,'PrincipalPoint',0,'CameraMatrix',0,'RotationMatrix',0,'TranslationVector',0);

for i = 1:len
   fp = fopen(filepath{i});
   data = textscan(fp,'%s');
   Para(i).Image_ID = data{1}(2);
   Para(i).FocalLength = data{1}(4);
   Para(i).PixelSize = [data{1}(6) data{1}(7)];
   Para(i).SensorSize = [data{1}(9) data{1}(10)];
   Para(i).PrincipalPoint = [data{1}(12) data{1}(13)];
   Para(i).CameraMatrix = [data{1}(15) data{1}(16) data{1}(17);
                           data{1}(18) data{1}(19) data{1}(20);
                           data{1}(21) data{1}(22) data{1}(23)];
   Para(i).RotationMatrix = [data{1}(25) data{1}(26) data{1}(27);
                             data{1}(28) data{1}(29) data{1}(30);
                             data{1}(31) data{1}(32) data{1}(33)];
   Para(i).TranslationVector = [data{1}(35) data{1}(36) data{1}(37)];
   
   parameter=Para;
   
   
   
end
fclose('all');
end