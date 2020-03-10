% Image Features: Features of the images that will be evaluated.
%   The features of each image must be in a colum, each column is a
%   different image

% function [evaluations_297,evaluations_Q1OU,evaluations_Q2OU,evaluations_Q1OA,evaluations_Q2OA] = ...
%    Metrics_Calculation(image_features)

function [Qodu,Q1odu,Q2odu,Qoda,Q1oda,Q2oda,MY] = Metrics_Calculation(image_features,training)

im_features = image_features;
num_im = size(image_features,2);

addpath('OU_metric_tools')
load('CalculatedFeatures/features_Pristine_306.mat','pristine_features')

indexes = {1,2,3,4,[5,9,13,17],[6,10,14,18],[7,11,15,19],[8,12,16,20],...
        [21,23,25,27,29,31,33],[22,24,26,28,30,32,34],[35,37,39,41,43,45],[36,38,40,42,44,46],...
        47,48,49,50,...
    [51,55,59,63],[52,56,60,64],[53,57,61,65],[54,58,62,66],[67,69,71,73,75,77,79],...
    [68,70,72,74,76,78,80],[81,83,85,87,89,91],[82,84,86,88,90,92],93,94,95,96,...
    [97,101,105,109],[98,102,106,110],[99,103,107,111],[100,104,108,112],...
    [113,115,117,119,121,123,125],[114,116,118,120,124,126],[127,129,131,133,135,137],...
    [128,130,132,134,136,138],139,140,141,142,143,144,145,146,147,148,149,150,...
    151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,...
    [166:177],[178:183],[184:195],[196:210],[211:235],[236:260],...
    [261:285],...
    286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306};


Qodu = zeros(num_im,1);
Q1odu = zeros(num_im,1);
Q2odu = zeros(num_im,1);
Qoda = zeros(num_im,1);
Q1oda = zeros(num_im,1);
Q2oda = zeros(num_im,1);
MY = zeros(num_im,1);

%% ODU

% Qodu

pr_features = pristine_features;

[~,model,~] = mixGaussEm(pr_features,1);
covM = model.Sigma;
mu = model.mu;

inv_diag_covM = 1./diag(covM);

for n = 1:num_im
    Qodu(n) = OU_metric(im_features(:,n),inv_diag_covM,mu);
end

% Q1odu

selected_features_Q1 = [5,7,11,16,18,19,28,30,31,44,49,58,65,88,3,1,72];

feats = [];
for n = 1:length(selected_features_Q1)
    feats = [feats indexes{selected_features_Q1(n)}];
end

pr_features = pristine_features(feats,:);

[~,model,~] = mixGaussEm(pr_features,1);
covM = model.Sigma;
mu = model.mu;

inv_diag_covM = 1./diag(covM);

for n = 1:num_im
    Q1odu(n) = OU_metric(im_features(feats,n),inv_diag_covM,mu);
end

% Q2odu

selected_features_Q2 = [18,49,30,40,41,11,27,45,26,25,47,63,84,12,48,57,83,77,91,80,79,85,82,69,15,39,90,89,78,3,56,75,81];

feats = [];
for n = 1:length(selected_features_Q2)
    feats = [feats indexes{selected_features_Q2(n)}];
end

pr_features = pristine_features(feats,:);

[~,model,~] = mixGaussEm(pr_features,1);
covM = model.Sigma;
mu = model.mu;

inv_diag_covM = 1./diag(covM);

for n = 1:num_im
    Q2odu(n) = OU_metric(im_features(feats,n),inv_diag_covM,mu);
end


%% ODA

addpath('OA_metric_tools/randomforest-matlab/RF_Reg_C')
addpath('OA_metric_tools')

flg = 0;
if strcmp(training,'SRIJ')
    flg = 1;
    load('OA_metric_tools/Training_Info/MY_SRIJ.mat','rf','B')
    rf_MY = rf;
    B_MY = B;
    load('OA_metric_tools/Training_Info/306_IQA_SR_Javeriana_all.mat','rf','B')
    load('OA_metric_tools/Training_Info/Q1_SRIJn.mat','B_Q1','rf_Q1')
    load('OA_metric_tools/Training_Info/Q2_SRIJn.mat','B_Q2','rf_Q2')
    
elseif strcmp(training,'MY')
    flg = 1;
    load('OA_metric_tools/Training_Info/MY_MY.mat','rf','B')
    rf_MY = rf;
    B_MY = B;
    load('OA_metric_tools/Training_Info/306_Ma_Yang_all.mat','rf','B')
    load('OA_metric_tools/Training_Info/Q1_MYn.mat','B_Q1','rf_Q1')
    load('OA_metric_tools/Training_Info/Q2_MYn.mat','B_Q2','rf_Q2')
    
else
    disp('Please select MY or SRIJ as the training')
end

if flg

    for n = 1:num_im
        s1=regRF_predict(im_features(:,n)',rf{1});
        Qoda(n) = [1 s1]*B;
    end

    Qoda = predict_general(im_features',num_im,B,rf);
    Q1oda = predict_Q1(im_features',num_im,B_Q1,rf_Q1);
    Q2oda = predict_Q2(im_features',num_im,B_Q2,rf_Q2);
    MY = predict_MY(im_features(139:285,:)',num_im,B_MY,rf_MY);

end