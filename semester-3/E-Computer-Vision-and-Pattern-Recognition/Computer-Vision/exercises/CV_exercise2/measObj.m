function [pixelcoord] = measObj(imgID, n)
% MEASOBJ measures object points in all available images.
%   Input:
%       imgID: Name list of image files
%       n: Number of measured points in each image
%   Output:
%       pixelcoord: Pixel coordinates of measured points
len = length(imgID);
pixelcoord = zeros(n,2,len);
for i = 1:len
    imshow(imgID{i});
    title(sprintf('%.8s',imgID{i}));
    set(gcf,'outerposition',get(0,'screensize'));    
    [x,y] = getline();
    l = length(x);
    if l~=n
        return;
    end
    pixelcoord(:,:,i) = [x y];
end
close all;