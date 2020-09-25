% Test

% place the images to extract the features from in the folder testImages
imDir = dir('testImages');
imDir = imDir(3:end);

image_features = zeros(306,size(imDir,1));
for i = 1:size(imDir,1)
    fprintf('%d\n',i)
    im = imread(['testImages/',imDir(i).name]);
    [image_features(:,i),~] = Calculate_All_Features(im);
end


% load('CalculatedFeatures/featuresSRIJ.mat','image_features')

% Write either 'MY' or 'SRIJ' to select a training dataset
% The models are already trained, it is to select the model

[Qodu,Q1odu,Q2odu] = Metrics_Calculation_ODU(image_features);

% [Qodu,Q1odu,Q2odu,Qoda,Q1oda,Q2oda,MY] = Metrics_Calculation(image_features,'MY');