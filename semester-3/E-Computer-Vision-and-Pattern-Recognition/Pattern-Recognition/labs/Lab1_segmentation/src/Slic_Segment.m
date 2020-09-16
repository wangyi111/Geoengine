function [output]=Slic_Segment(option,gt,img,k,compactness,method)
% simple linear iterative clustering
% input   gt: label  fv: pixelwise feature vector (origin image with
% multiple bands) compactness: usually [0,20]
% method=slic0 (changable compactness) or slic (constant compactness)
% output: struct including mask, feature, RGB, label, etc.
% Yi
tic;
lab=rgb2lab(img);
[L,NumLabels] = superpixels(lab,k,'Compactness',compactness,'method',method);
runtime=toc;

mask=L;

mask_3=repmat(mask,[1,1,3]);
feature=zeros(NumLabels,5);
Seg_RGB=zeros(size(img));
Seg_label=zeros(size(mask));
List_label=zeros(NumLabels,1);
for i=1:NumLabels
    logic=mask_3==i;
    temp=img.*single(logic);
    value=sum(sum(temp))./sum(sum(logic));
    feature(i,1:3)=value;
    Seg_RGB = Seg_RGB + value.*double(logic);
    
    [row,col]=find(mask==i);
    feature(i,4:5)=[mean(row),mean(col)];
    
    if(strcmp(option,'train'))
        
    logic2=mask==i;
    label=mode(gt(logic2));
    Seg_label=Seg_label+single(label)*logic2;    
    List_label(i)=label;
        
    end

end
if(strcmp(option,'train'))
accuracy = length(find((Seg_label - single(gt))==0)) / (size(gt,1)*size(gt,2));
Seg_bw = boundarymask(mask);
elseif(strcmp(option,'test'))
    accuracy=NaN;
    Seg_bw=[];
end

output = struct('Mask',mask,'Feature_List',feature,'Label_List',List_label,'Seg_RGB', Seg_RGB,'Seg_Label',Seg_label,'Accuracy',accuracy,'Seg_k',NumLabels,'Seg_compactness',compactness,'Seg_time',runtime,'Seg_Border',Seg_bw);


end