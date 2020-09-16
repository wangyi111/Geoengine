function [output]=Kmeans_Segment(gt,fv,k,itr)
% Kmeans clustering
% input   gt: label  fv: pixelwise feature vector (origin image with
% multiple bands) k: number of clusters  itr: maximum iteration 
% output: struct including mask, feature, RGB, label, etc.
% Yi
tic;

[length_x,length_y,length_z]=size(fv);

I_data=reshape(fv,length_x*length_y,length_z);
[idx,ct]=kmeans(I_data,k,'MaxIter',itr);
mask=reshape(idx,length_x,length_y);

Seg_RGB=zeros(size(fv));
Seg_Label=zeros(length_x,length_y);
Seg_RGB=reshape(Seg_RGB,length_x*length_y,length_z,1);
List_label=zeros(k,1);
for i=1:k

    mask_2=reshape(mask,length_x*length_y,1);
    logic1=mask_2==i;
    
    Seg_RGB = Seg_RGB + repmat(logic1,1,length_z).*repmat(ct(i,:),length_x*length_y,1);

    logic2=mask==i;
    label=mode(gt(logic2));
    List_label(i)=label;
    Seg_Label=Seg_Label+single(label)*logic2;
    

    
end

Seg_RGB=reshape(Seg_RGB,size(fv));


accuracy = length(find((Seg_Label - single(gt))==0)) / (size(gt,1)*size(gt,2));
Seg_bw = boundarymask(mask);

runtime=toc;
output = struct('Mask',mask,'Feature_List',ct,'Label_List',List_label,'Seg_RGB', Seg_RGB,'Seg_Label',Seg_Label,'Accuracy',accuracy,'Seg_k',k,'Seg_maxiter',itr,'Seg_time',runtime,'Seg_Border',Seg_bw);




end