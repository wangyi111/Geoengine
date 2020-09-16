%% CV Exercise 2
% Spatial Intersection and Resection
% author: yiwang 3371561
% 09/01/2020
% 21/01/2020 resubmit: add centralization
clear;
clc;

%% 1. P matrix & plot pixel points
filepath_20851={'20851.ori'};
Para_20851=read_ori(filepath_20851);
P_1=Proj_matrix(Para_20851);
P_20851=P_1{1};

data_1=load('Signalized_Points_R0020851.txt');
X_20851 = [data_1(:,2) data_1(:,3) data_1(:,4) ones(length(data_1(:,1)),1)];
X_20851 = X_20851';
x_20851 = P_20851*X_20851;                           % Transform coordinates
x_20851 = x_20851./x_20851(3,:);
figure();                                                %%
imshow('R0020851.jpg');                                        % Plot the pixel coordinates
hold on;
scatter(x_20851(1,:),x_20851(2,:),'MarkerFaceColor', 'r');
text(x_20851(1,:),x_20851(2,:),num2str(data_1(:,1)),'Color','r');
% plot settings
%plot(x_20851(1,:),x_20851(2,:),'y^','MarkerSize',10);    %%.............................................................
%text(x1_R0020851,x2_R0020851,num2str(data(:,1)),'FontSize',15,'Color','r');
%hold off;
%set(gcf,'outerposition',get(0,'screensize'));   
%leg = legend('Signalized points','Location','SouthEastOutside');
%set(leg,'Box','off');
disp('** T1 ***********************************');
P_20851
x_20851

%% 2. measure pixel coordinates
filepath_img={'R0020813.jpg','R0020814.jpg','R0020815.jpg','R0020816.jpg','R0020849.jpg','R0020850.jpg','R0020851.jpg','R0020852.jpg'};
len=length(filepath_img);
pixel=cell(1,len);
for i=1:len
    figure();
    imshow(filepath_img{i});
    title(sprintf('%.8s',filepath_img{i}));
    [x,y]=getline(); % right click
    if(length(x)~=1)
        disp('Please right click one point only!');
        return;
    end
    pixel{i}=[x;y];
    close();
end
    
%% 3. spatial intersection
filepath_ori={'20813.ori','20814.ori','20815.ori','20816.ori','20849.ori','20850.ori','20851.ori','20852.ori'};
Para_all=read_ori(filepath_ori);
P_all=Proj_matrix(Para_all);
obj=spation_intersection(pixel,P_all);
disp('** T3 *********************************');
obj

%% 4. back transformation & errors
for i=1:len
    pixel_b{i}=P_all{i}*obj;
    pixel_b{i}=pixel_b{i}./pixel_b{i}(3);
    pixel_b{i}(3)=[];
    diff(:,i)=pixel_b{i}-pixel{i};
    
end
sigma0_x = sqrt(sum(diff(1,:).^2)/(2*len-3));
sigma0_y = sqrt(sum(diff(2,:).^2/(2*len-3)));

disp('** T4 *********************************');
sigma0_x
sigma0_y


%% 5. direct linear transformation
X_20851_m = repmat(mean(X_20851'),7,1)';
X_20851_m(4,:) = 0;
X_20851_c = X_20851-X_20851_m;  % Centralization 
P_20851_B=DirectLinearTransform(x_20851,X_20851_c);
disp('** T5 *********************************');
P_20851_B

%% 6. re-mapping & diff
x_20851_R=P_20851_B*X_20851_c;
x_20851_R = x_20851_R./x_20851_R(3,:);
diff_T6=x_20851-x_20851_R;
sigma0_T6_x = sqrt(sum(diff_T6(1,:).^2)/(2*length(diff_T6(1,:))-3));
sigma0_T6_y = sqrt(sum(diff_T6(2,:).^2)/(2*length(diff_T6(1,:))-3));
figure();
imshow('R0020851.jpg');                                      
hold on;
scatter(x_20851(1,:),x_20851(2,:),'MarkerEdgeColor','r','MarkerFaceColor', 'r');
text(x_20851(1,:),x_20851(2,:),num2str(data_1(:,1)),'Color','r');
hold on;
scatter(x_20851_R(1,:),x_20851_R(2,:),'MarkerEdgeColor','b','MarkerFaceColor', 'b');
text(x_20851_R(1,:),x_20851_R(2,:),num2str(data_1(:,1)),'Color','b');
disp('** T6 *********************************');
x_20851_R
sigma0_T6_x
sigma0_T6_y

%% 7. reconstruct camera parameter
[X0,K,R]=camera_reconstruction(P_20851_B);
disp('** T7 *********************************');
X0=X0+X_20851_m(:,1)
K
R
diff_X0=X0(1:3)-str2double(Para_20851.TranslationVector)'
diff_K=K-str2double(Para_20851.CameraMatrix)
diff_R=R-str2double(Para_20851.RotationMatrix)


%% Functions
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
% calculate projection matrix
function [p_matrix]=Proj_matrix(Para)

len=length(Para);
%P = zeros(3,4);
p_matrix=cell(1,len);
for i = 1:len
    R =  str2double(Para(i).RotationMatrix);             % World to image coordinate frame
    X0 = str2double(Para(i).TranslationVector);          % Coordinates of perspective center
    D = [R  -R*X0'];
    K = str2double(Para(i).CameraMatrix);
    P = K*D;                             % Projection matrix
    p_matrix{i}=P;
end
end
% spatial intersection
function [Obj]=spation_intersection(pixel,P)
A=zeros(2*length(P),4);
for i=1:length(P)
    x=pixel{i}(1);
    y=pixel{i}(2);
    p1T=P{i}(1,:);
    p2T=P{i}(2,:);
    p3T=P{i}(3,:);
    A((2*i-1):2*i,:)=[x*p3T-p1T;y*p3T-p2T];
end

[U,V,X]=svd(A,0);
X=X(:,end);
Obj=X./X(4);

end
% direct linear transform
function [p_matrix]=DirectLinearTransform(pixel,obj)
len=length(pixel(1,:));
A=zeros(len*2,12);
for i=1:len
    x=pixel(1,i);
    y=pixel(2,i);
    w=pixel(3,i);
    X=obj(:,i);
    A((2*i-1):2*i,:)=[zeros(1,4),-w*X',y*X';
                      w*X',zeros(1,4),-x*X'];
end
[U,D,V]=svd(A,0);
p_matrix=reshape(V(:,12),4,3)';
end
% reconstruct camera parameter
function [X0,K,R]=camera_reconstruction(P)
[U,D,V]=svd(P,0);
X0=V(:,end);
X0=X0./X0(4);
M=P(:,1:3);
[q,r]=qr(inv(M));
K=inv(r);
K=K./K(9);
R=inv(q);
end
