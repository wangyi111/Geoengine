
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test.m 
% ------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all; format longG; close all; clc;
% run init;
% %#ok<*NOPTS>
% warning('off', 'Images:initSize:adjustingMag');
% rng(1);
% 
% 
% 
% %% Parameters:
% % Input:
% scale  = 1
% r_train      = 3   % tile row
% c_train      = 12  % tile column
% r_test      = 3   % tile row
% c_test      = 13  % tile column
% disp('----------------------------')
% 
% 
% 
% %% Load Data:
% % Load data by row / column number:
% 
% RGBIR_tr = single(d_RGBIR.loadData(r_train, c_train))/255;
% RGB_tr   = RGBIR_tr(:,:,1:3);
% IR_tr    = RGBIR_tr(:,:,4);
% 
% nDSM_tr  = single(d_nDSM.loadData(r_train, c_train));
% nDSM_tr  = (nDSM_tr - min(nDSM_tr(:))) / (max(nDSM_tr(:)) - min(nDSM_tr(:)));
% 
% gt_tr    = d_GT.loadData(r_train, c_train);
% gt_tr    = uint8(data.potsdam.rgbLabel2classLabel(gt_tr));
% 
% RGB_tr   = imresize(RGB_tr,  scale,  'method', 'nearest');
% nDSM_tr  = imresize(nDSM_tr, scale,  'method', 'nearest');
% IR_tr    = imresize(IR_tr,   scale,  'method', 'nearest');
% gt_tr    = imresize(gt_tr,   scale,  'method', 'nearest');
% 
% 
% RGBIR_te = single(d_RGBIR.loadData(r_test, c_test))/255;
% RGB_te   = RGBIR_te(:,:,1:3);
% IR_te    = RGBIR_te(:,:,4);
% 
% nDSM_te  = single(d_nDSM.loadData(r_test, c_test));
% nDSM_te  = (nDSM_te - min(nDSM_te(:))) / (max(nDSM_te(:)) - min(nDSM_te(:)));
% 
% gt_te    = d_GT.loadData(r_test, c_test);
% gt_te    = uint8(data.potsdam.rgbLabel2classLabel(gt_te));
% 
% RGB_te   = imresize(RGB_te,  scale,  'method', 'nearest');
% nDSM_te  = imresize(nDSM_te, scale,  'method', 'nearest');
% IR_te    = imresize(IR_te,   scale,  'method', 'nearest');
% gt_te    = imresize(gt_te,   scale,  'method', 'nearest');
% %% Show image
% % training
% figure;
% imshow(RGB_tr);
% title(sprintf('Input training image RGB, scale = %f',scale));
% 
% figure;
% imshow(IR_tr);
% title(sprintf('Input training image IR, scale = %f',scale));
% 
% figure;
% imshow(nDSM_tr, []);
% title(sprintf('Input training image nDSM, scale = %f',scale));
% 
% figure;
% imshow(gt_tr, getColorMap('V2DLabels'));
% title(sprintf('Input labels of training image, scale = %f',scale));
% 
% figure;
% imshow(RGB_te);
% title(sprintf('Input test image RGB, scale = %f',scale));
% 
% figure;
% imshow(IR_te);
% title(sprintf('Input test image IR, scale = %f',scale));
% 
% figure;
% imshow(nDSM_te, []);
% title(sprintf('Input test image nDSM, scale = %f',scale));
% 
% figure;
% imshow(gt_te, getColorMap('V2DLabels'));
% title(sprintf('Input labels of test image, scale = %f',scale));
% 
% %% Create feature vector
% fv_te=cat(3,RGB_te,IR_te,nDSM_te);
% fv_tr=cat(3,RGB_tr,IR_tr,nDSM_tr);
% 
% %% Chessboard Segment
% SegChess_train = Chess_Segment(gt_tr,fv_tr,30,30);
% SegChess_test = Chess_Segment(gt_te,fv_te,30,30);

% %% SLIC Segment


%% Random Forest

% for training data, biuld and train random forest
F_chess=TreeBagger(30,SegChess_train.Feature_List,SegChess_train.Label_List,'Method','Classification');
% F_SLIC=TreeBagger(30,SegSLIC_train.Feature_List,SegSLIC_train.Label_List,'Method','Classification');

% use radom forest to predict classes

% for training data
P_chess_tr = F_chess.predict(SegChess_train.Feature_List);

% P_SLIC_tr = F_chess.predict(SegSLIC_train.Feature_List);

% for test data
P_chess_te=F_chess.predict(SegChess_test.Feature_List);


% P_SLIC_te=F_chess.predict(SegSLIC_test.Feature_List);


%% Generate Output
% A list of predicted labels, one per segment.

P_chess_tr = uint8(str2num(cell2mat(P_chess_tr)));
P_chess_te = uint8(str2num(cell2mat(P_chess_te)));
% P_SLIC_tr = uint8(str2num(cell2mat(P_SLIC_tr)));
% P_SLIC_te = uint8(str2num(cell2mat(P_SLIC_te)));


% The image with its segments filled with their respective predicted labels.
figure()
imshow(P_chess_tr(SegChess_train.Mask),getColorMap('V2DLabels'));
title(sprintf('Predicted labels of train image, scale = %f',scale));

figure()
imshow(P_chess_te(SegChess_test.Mask),getColorMap('V2DLabels'));
title(sprintf('Predicted labels of test image, scale = %f',scale));

% figure()
% imshow(P_SLIC_tr(SegSLIC_train.Mask),getColorMap('V2DLabels'));
% figure()
% imshow(P_SLIC_te(SegSLIC_test.Mask),getColorMap('V2DLabels'));

%% Confision Matrix
[C_chess_tr,~]=confusionmat(reshape(gt_tr,1,[]),reshape(P_chess_tr(SegChess_train.Mask),1,[]));
[C_chess_te,~]=confusionmat(reshape(gt_te,1,[]),reshape(P_chess_te(SegChess_test.Mask),1,[]));
% [C_SLIC_tr,~]=confusionmat(reshape(gt_tr,1,[]),reshape(P_SLIC_tr(SegChess_train.Mask),1,[]));
% [C_SLIC_te,~]=confusionmat(reshape(gt_te,1,[]),reshape(P_SLIC_te(SegChess_test.Mask),1,[]));

%% Performance Quantities
% Producer?s accuracy / recall / sensitivity
AccPro_chess_tr = diag(C_chess_tr)./sum(C_chess_tr,1)';
AccPro_chess_te = diag(C_chess_te)./sum(C_chess_te,1)';
% AccPro_SLIC_tr = diag(C_SLIC_tr)./sum(C_SLIC_tr,1)';
% AccPro_SLIC_te = diag(C_SLIC_te)./sum(C_SLIC_te,1)';
% User?s accuracy / precision
AccUser_chess_tr = diag(C_chess_tr)./sum(C_chess_tr,2);
AccUser_chess_te = diag(C_chess_te)./sum(C_chess_te,2);
% AccUser_SLIC_tr = diag(C_SLIC_tr)./sum(C_SLIC_tr,2);
% AccUser_SLIC_te = diag(C_SLIC_te)./sum(C_SLIC_te,2);
% Total accuracy / overall accuracy
AccAll_chess_tr = trace(C_chess_tr)/sum(sum(C_chess_tr));
AccAll_chess_te = trace(C_chess_te)/sum(sum(C_chess_te));
% AccAll_SLIC_tr = trace(C_SLIC_tr)/sum(sum(C_SLIC_tr));
% AccAll_SLIC_te = trace(C_SLIC_te)/sum(sum(C_SLIC_te));