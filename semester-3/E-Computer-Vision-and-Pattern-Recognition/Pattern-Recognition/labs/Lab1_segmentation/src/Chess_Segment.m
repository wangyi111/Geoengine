function [Output] = Chess_Segment(gt,fv,r,c)
% Chessboard Segmentation
% input   gt: label  fv: pixelwise feature vector (origin image with
% multiple bands) r,c: segment size
% output: struct including mask, feature, RGB, label, etc.
%   Tianqi Xiao
%   3371477
tic;
%% Generate Mask
% number of clusters
k=size(fv,1)/r*size(fv,2)/c;
Kernel=ones(r,c);
% Segment mask
mask =cell2mat(reshape(arrayfun(@(p) Kernel*p, 1:k, 'UniformOutput', false),size(fv,1)/r,size(fv,2)/c)');
% image feature vector
Img_fv=cat(3,fv,mask);
Seg_fv=blockproc(Img_fv, [r,c],@(p) mean(mean(p.data)));
% respective feature
Img_res=repelem(Seg_fv,r,c);
Seg_label=blockproc(gt, [r,c],@(p) mode(mode(p.data)));
Img_label=repelem(Seg_label,r,c);
% sort features and label from mat to list
List_fv=sortrows(reshape(Seg_fv,k,[]),6);
List_label=reshape(Seg_label',k,[]);
% get boundaries of segment
Seg_bw = boundarymask(mask);

accuracy = length(find((Img_label - gt)==0)) / (size(gt,1)*size(gt,2));

runtime=toc; 
Output = struct('Mask',mask,'Feature_List',List_fv,'Label_List',List_label,'Seg_RGB', Img_res,'Seg_Label',Img_label,'Accuracy',accuracy,'Seg_k',k,'Seg_time',runtime,'Seg_Border',Seg_bw);


end

