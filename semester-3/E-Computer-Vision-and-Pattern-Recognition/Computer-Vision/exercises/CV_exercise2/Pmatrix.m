function [P] = Pmatrix(ori)
% PMATRIX computes corresponding projection matrix from .ori files
%   Input:
%       ori: Name list of .ori files
%   Output:
%       P: Projection matrix 
imgStruct = imgParm(ori);
len = length(imgStruct);
P = zeros(3*len,4);
count = 0;
for i = 1:len
    R =  str2double(imgStruct(i).RotationMatrix);             % World to image coordinate frame
    X0 = str2double(imgStruct(i).TranslationVector);          % Coordinates of perspective center
    D = [R  -R*X0'];
    K = str2double(imgStruct(i).CameraMatrix);
    P(i+count:i+count+2,:) = K*D;                             % Projection matrix
    count = count+2;
end