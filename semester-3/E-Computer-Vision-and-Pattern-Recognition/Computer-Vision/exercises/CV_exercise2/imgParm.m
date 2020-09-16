function [imgStruct] = imgParm(ori)
% IMGPARM reads .ori files and extract image parameters into structures 
%   Input:
%       ori: Name list of .ori files
%   Output:
%       imgStruct: Image parameters in the form of structures    
len = length(ori);
imgStruct(len) = struct('ID',0,'FocalLength',0,'PixelSize',0,'SensorSize',0,...
                        'PrincipalPoint',0,'CameraMatrix',0,'RotationMatrix',0,...
                        'TranslationVector',0);     % Initialize structures
for i = 1:len
   fid = fopen(string((ori(i))));
   img = textscan(fid,'%s');
   ID = strcat('R00',img{1}(2));
   f = img{1}(4);
   ps = [img{1}(6) img{1}(7)];
   ss = [img{1}(9) img{1}(10)];
   pp = [img{1}(12) img{1}(13)];
   cm = [img{1}(15) img{1}(16) img{1}(17);
         img{1}(18) img{1}(19) img{1}(20);
         img{1}(21) img{1}(22) img{1}(23)];
   rm = [img{1}(25) img{1}(26) img{1}(27);
         img{1}(28) img{1}(29) img{1}(30);
         img{1}(31) img{1}(32) img{1}(33)];
   tv = [img{1}(35) img{1}(36) img{1}(37)];
   imgStruct(i).ID = ID;
   imgStruct(i).FocalLength = f;
   imgStruct(i).PixelSize = ps;
   imgStruct(i).SensorSize = ss;
   imgStruct(i).PrincipalPoint = pp;
   imgStruct(i).CameraMatrix = cm;
   imgStruct(i).RotationMatrix = rm;
   imgStruct(i).TranslationVector = tv;
end
fclose('all');