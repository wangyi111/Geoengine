% CV Exercise 2: Spatial Intersection and Resection
% Name: Yi Hong
% ID: 3294211
clc
clear
%% part 1 transform from obj to pixel
P_R0020851 = Pmatrix({'20851.ori'});                           % Projection matrix using paramters 
data = load('Signalized_Points_R0020851.txt');                 % given in the file "R0020851.ori"
X1_R0020851 = data(:,2);
X2_R0020851 = data(:,3);
X3_R0020851 = data(:,4);
l = length(X1_R0020851);
X_R0020851 = [X1_R0020851 X2_R0020851 X3_R0020851 ones(l,1)];  % Homogeneous coordinates
x_R0020851 = P_R0020851*X_R0020851';                           % Transform coordinates
x_R0020851 = x_R0020851./x_R0020851(3,:);
x1_R0020851 = x_R0020851(1,:);
x2_R0020851 = x_R0020851(2,:);
figure(1)                                                %%
imshow('R0020851.jpg');                                        % Plot the pixel coordinates
hold on;
plot(x1_R0020851,x2_R0020851,'y^','MarkerSize',10);    %%.............................................................
text(x1_R0020851,x2_R0020851,num2str(data(:,1)),'FontSize',15,'Color','r');
hold off;
set(gcf,'outerposition',get(0,'screensize'));   
leg = legend('Signalized points','Location','SouthEastOutside');
set(leg,'Box','off');

% %% part 2,3,4 Spatial intersection
% imgID = {'R0020813.jpg','R0020814.jpg','R0020815.jpg','R0020816.jpg'...
%          'R0020849.jpg','R0020850.jpg','R0020851.jpg','R0020852.jpg'}; 
% len = length(imgID);
% pixcoord_meas = measObj(imgID,1);                              % Measure points..........................................
% oriID = {'20813.ori','20814.ori','20815.ori','20816.ori',...
%        '20849.ori','20850.ori','20851.ori','20852.ori'};         
% P = Pmatrix(oriID);                                            % Compute projection matrices
% A = zeros(2*len,4);                                            % Set up linear system
% for i = 1:len
%     A(2*i-1:2*i,:) = [pixcoord_meas(1,1,i)*P(3*i,:)-P(3*i-2,:);
%                       pixcoord_meas(1,2,i)*P(3*i,:)-P(3*i-1,:);];
% end
% [U,D,V] = svd(A,0);                                            % Singular value decomposition
% X = V(:,end);
% objcoord = X(:)./X(4);
% pixelcoord_trafo = P*objcoord;
% pixelcoord_trafo = reshape(pixelcoord_trafo,3,[]);
% pixelcoord_trafo = pixelcoord_trafo./pixelcoord_trafo(3,:);
% pixelcoord_trafo(3,:) = [];
% res = reshape(pixcoord_meas,2,8)-pixelcoord_trafo;             % Estimated errors
% sigma0_x = sqrt(sum(res(1,:).^2)/(2*len-3));
% sigma0_y = sqrt(sum(res(2,:).^2/(2*len-3)));

%% part 5&6 Direct Linear Transformation
[x_R0020851_meas] = measObj({'R0020851.jpg'},l);           %..................................................................

X_R0020851_m = mean(X_R0020851);
X_R0020851_m(4) = 0;
X_R0020851_c = X_R0020851-X_R0020851_m;  % Centralization 

O = zeros(1,4);
A_dlt = zeros(2*l,12);
for i = 1:l
    A_dlt(2*i-1:2*i,:) = [O -X_R0020851_c(i,:) x_R0020851_meas(i,2)*X_R0020851_c(i,:);
                          X_R0020851_c(i,:) O -x_R0020851_meas(i,1)*X_R0020851_c(i,:)];
end
[U_dlt,D_dlt,V_dlt] = svd(A_dlt,0); 
P_dlt = reshape(V_dlt(:,12),4,3)';
x_dlt = P_dlt*X_R0020851_c';
x_dlt = x_dlt./x_dlt(3,:);    
res1 = x_R0020851-x_dlt;
sigma0_x1 = sqrt(sum(res1(1,:).^2)/(2*l-3));
sigma0_y1 = sqrt(sum(res1(2,:).^2/(2*l-3)));

figure(2)
imshow('R0020851.jpg');
hold on;
plot(x_dlt(1,:),x_dlt(2,:),'rx','MarkerSize',20);         %..................................................
plot(x1_R0020851,x2_R0020851,'g^','MarkerSize',20);
hold off;
leg = legend('Computed points from DLT','Original points','Location','SouthEastOutside');%'Computed points from DLT',
set(leg,'Box','off');
set(gcf,'outerposition',get(0,'screensize'));   

%% part 7 Reconstruct the camera parameters
M = P_dlt(:,1:3);
[Q,R] = qr(inv(M));                                           % QR decomposition, Q is orthogonal,R is upper triangular
img20851 = imgParm({'20851.ori'});                            % Original camera parameters
RM = str2double(img20851.RotationMatrix);
TV = str2double(img20851.TranslationVector);     
CM = str2double(img20851.CameraMatrix);

RM_dlt = Q';                                                  % Difference
res_rm = RM-RM_dlt;                                               
IX = M\P_dlt;
TV_dlt = -IX(:,4)'+X_R0020851_m(:,1:3);
res_tv = TV-TV_dlt;
CM_dlt = R./R(3,3);
CM_dlt = inv(CM_dlt);
res_cm = CM-CM_dlt;