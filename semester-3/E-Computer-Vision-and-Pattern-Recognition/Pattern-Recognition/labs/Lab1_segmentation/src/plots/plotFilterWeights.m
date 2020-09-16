function [] = plotFilterWeights(w, layerNumber)
%PLOTFILTERWEIGHTS Summary of this function goes here
%   Detailed explanation goes here


% Rescale the weights to the range [0, 1] for better visualization:
w = rescale(w);

% RGB:
figure;
montage(w(:,:,1:3,:))

% Channel-weise greayscale:
for j=1:5
    f = 20;
    w_ = zeros(size(w,1)*f, size(w,2)*f, size(w,4));
    for i=1:size(w,4)
        w_(:,:,i) = kron(w(:,:,j,i), ones(f));
    end
    figure
    montage(w_, 'BorderSize', [10,10])
    title(sprintf('Weights from Layer %d; Channel %d',layerNumber, j));
end
    
end

