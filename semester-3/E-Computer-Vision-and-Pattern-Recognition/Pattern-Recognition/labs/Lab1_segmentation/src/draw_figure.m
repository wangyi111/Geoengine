%% plot figures
% Yi
set(0,'defaultfigurecolor','w');
load('Slic_20000_5.mat');

    colorMap = [
                1 1 1;
                0 0 1;
                0 1 1;
                0 1 0;
                1 1 0;
                1 0 0];
            
% figure;
% imshow(Seg_Kmeans.Seg_Label,colorMap);
% title(sprintf('Kmeans segment labels, k = %d',Seg_Kmeans.Seg_k));

          
            
            
 
figure;
imshow(Seg_Slic.Seg_Label,colorMap);
title(sprintf('Slic segment labels, k = %d, "slic0"',Seg_Slic.Seg_k));

figure;

imshow(Seg_Slic.Mask,[]);
title(sprintf('Slic segment mask, k = %d, "slic0"',Seg_Slic.Seg_k));


figure;
imshow(imoverlay(fv(:,:,1:3),Seg_Slic.Seg_Border,'cyan'),'InitialMagnification',67);
title(sprintf('Slic segment Boundary, k= %d ,"slic0"',Seg_Slic.Seg_k));

figure;
imshow(Seg_Slic.Seg_RGB);
title(sprintf('Slic segment means, k = %d, "slic0"',Seg_Slic.Seg_k));

