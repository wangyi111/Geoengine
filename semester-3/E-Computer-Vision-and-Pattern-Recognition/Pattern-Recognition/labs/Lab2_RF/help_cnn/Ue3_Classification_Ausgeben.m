%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ue3_Classification.m 
% ------------------
% Demo for classification / object detection exercise in pattern 
% recognition.
% Bounding boxes from image tiles are classified via CNN.
% Due to small training data, the CNN gets pre-trained on CIFAR-10.
%
% by Stefan Schmohl, 09.01.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; format longG; close all; clc;
run init;
%#ok<*NOPTS>
warning('off', 'Images:initSize:adjustingMag');
rng(1);





%% Parameters:

disp('Parameters:')

row_train    = 2
column_train = 10
row_test     = 2
column_test  = 11

pretraining         = true  % true if you want to fine-tune a CIFAR-10 net
pretraining_retrain = true  % false, if you want to load the CIFAR-10 net from disk (must have been trained before).
pretraining_plot    = true  % ...

potsdam_augment     = true
potsdam_plotData    = false
potsdam_plotResults = false % 



% Define network layers for "feature extraction":
middleLayers = [
    batchNormalizationLayer
    convolution2dLayer(3, 32, 'Padding', 'same')
    maxPooling2dLayer(2, 'Stride', 2)
    reluLayer()
    
    batchNormalizationLayer
    convolution2dLayer(3, 32, 'Padding', 'same')
    maxPooling2dLayer(2, 'Stride', 2)
    reluLayer()
    
    batchNormalizationLayer
    convolution2dLayer(3, 64, 'Padding', 'same')
    maxPooling2dLayer(2, 'Stride', 2)
    reluLayer()
]

% Define training parameters:
PotsdamParas = {'sgdm', ...
    'L2Regularization', 0.0005, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.7, ...
    'LearnRateDropPeriod', 10, ...
    'Shuffle', 'every-epoch', ...
    'MaxEpochs', 50 ...
    'MiniBatchSize', 32, ...
    'ValidationFrequency', 10, ...
    'ValidationPatience', 30, ...
    'Verbose',true, ... 
    'Plots','training-progress'}

PotsdamAugmt = {'RandRotation',[-20,20], ...
    'RandXTranslation',[-3 3], ...
    'RandYTranslation',[-3 3]}

fprintf('----------------------------\n\n')




%% Pretraining:

if pretraining
    fprintf('Pretraining on CIFAR-10... \n')

    % Download CIFAR-10 if not on disc:
    fprintf('Loading CIFAR-10... ')
    cifar10Data = PATH2DATA;
    url = 'https://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';
    helperCIFAR10Data.download(url, cifar10Data);
    [trainingImages, trainingLabels, testImages, testLabels] = helperCIFAR10Data.load(cifar10Data);
    fprintf('done.\n')

    % Each image is a 32x32 RGB image and there are 50,000 training samples.
    size(trainingImages)

    % CIFAR-10 has 10 image categories. List the image categories:
    categories(trainingLabels)
    numImageCategories = length(categories(trainingLabels));

    % Add 2 dimensions to CIFAR-10 in order to make it compatible as  
    % pretraining data for 5 channel data:
    trainingImages = cat(3, trainingImages, trainingImages(:,:,1:2,:));
    testImages = cat(3, testImages, testImages(:,:,1:2,:));
    [height, width, numChannels, ~] = size(trainingImages);
    imageSize = [height width numChannels];


    % Define the network for pretraining:
    CIFAR10Layers = [
        imageInputLayer(imageSize)
        
        middleLayers  
        
        fullyConnectedLayer(128)
        reluLayer
        fullyConnectedLayer(numImageCategories)
        softmaxLayer
        classificationLayer
    ];

    % Set the network training options
    CIFAR10opts = trainingOptions('sgdm', ...
        'Momentum', 0.9, ...
        'InitialLearnRate', 0.01, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.7, ...
        'LearnRateDropPeriod', 2, ...
        'L2Regularization', 0.005, ...
        'Shuffle', 'every-epoch', ...
        'MaxEpochs', 20, ...
        'MiniBatchSize', 128, ...
        'Verbose', true); 

    if pretraining_retrain
        fprintf('Training CIFAR-10 net from scratch... ');
        cifar10Net = trainNetwork(trainingImages, trainingLabels, CIFAR10Layers, CIFAR10opts);
        save('cifar10Net.mat', 'cifar10Net');
        fprintf('Finished Training CIFAR-10.\n');
    else
        fprintf('Loading CIFAR-10 net from file... ');
        load('cifar10Net.mat', 'cifar10Net');
        fprintf('done.\n');
    end

    % Run the network on the test set for evaluation and calc overall acc.:
    YTest = classify(cifar10Net, testImages);
    test_accuracy = sum(YTest == testLabels)/numel(testLabels)


    % Plot some stuff from pretraining:
    if pretraining_plot
        % Show some examples:
        figure
        thumbnails = trainingImages(:,:,1:3,1:100);
        montage(thumbnails)

        % Extract and plot the first convolutional layer weights:
        for i=1:length(cifar10Net.Layers)
            c = class(cifar10Net.Layers(i));
            if strcmp(c, 'nnet.cnn.layer.Convolution2DLayer')
                break
            end
        end
        plotFilterWeights(cifar10Net.Layers(i).Weights, 1);
    end

    disp('Finished Pretraining on CIFAR-10.')
    fprintf('----------------------------\n\n')
end



%% Load ISPRS 2D Semantic Labeling Potsdam data

fprintf('Loading Potsdam data... \n')

% Load tiles by row / coloumn number:
%
% TODO
%

% Load bounding boxes:
%
% TODO
%

% Load Samples (crops):
%
% TODO
%


if potsdam_plotData
    
    %
    % TODO
    %
end

disp('Finished Loading Potsdam data.')
fprintf('----------------------------\n\n')





%% Training (fine-tuning) on the Potsdam dataset:
fprintf('Training (fine-tuning) on Potsdam... \n')

if pretraining
	%
    % TODO
    %
else
    %
    % TODO
    %
end

% Define layers and training options:
%
% TODO
%


% Data Augmentation
if potsdam_augment
    %
    % TODO
    %
else
    imageAugmenter = imageDataAugmenter();  % identity transform.
end

                     
% Train the Network:
%
% TODO
%


% Evaluation:
%
% TODO
%


% Plotting:
if potsdam_plotResults
    
    fprintf('Plotting Potsdam Results ... ')
    
    %
    % TODO
    %
    fprintf('done.\n');
end

