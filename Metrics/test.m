% Test

% place the images to extract the features from in the folder testImages
imDir = dir('testImages');
imDir = imDir(3:end);

im = imread(['testImages/',imDir(1).name]);
[image_features,~] = Calculate_All_Features(im);


% load('CalculatedFeatures/featuresSRIJ.mat','image_features')

% Write either 'MY' or 'SRIJ' to select a training dataset
% The models are already trained, it is to select the model
[Qodu,Q1odu,Q2odu,Qoda,Q1oda,Q2oda,MY] = Metrics_Calculation(image_features,'MY');