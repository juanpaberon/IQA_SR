function [features,times] = Calculate_All_Features(im)

    times = zeros(1,10);
    
    if (size(im,3)~=1)
        im = rgb2gray(im);
    end

    if max(im) <= 1
        im = uint8(im);
    end

    addpath('FeaturesCalculationTools')

    features = [];

    [temp_features, temp_times] = Calculate_Features(im,[1,1,1,1,0,0,0,0,0,0]);
    times = times + temp_times;
    features = [features; temp_features];
    [temp_features, temp_times] = Calculate_Features(imresize(im,0.5),[1,1,1,1,0,0,0,0,0,0]);
    times = times + temp_times;
    features = [features; temp_features];
    [temp_features, temp_times] = Calculate_Features(imresize(im,0.25),[1,1,1,1,0,0,0,0,0,0]);
    times = times + temp_times;
    features = [features; temp_features];

    [temp_features, temp_times] = Calculate_Features(im,[0,0,0,0,1,1,1,0,0,0]);
    times = times + temp_times;
    features = [features; temp_features];

    [temp_features, temp_times] = Calculate_Features(im,[0,0,0,0,0,0,0,1,0,0]);
    times = times + temp_times;
    features = [features; temp_features];
    [temp_features, temp_times] = Calculate_Features(imresize(double(im),0.5),[0,0,0,0,0,0,0,1,0,0]);
    times = times + temp_times;
    features = [features; temp_features];
    [temp_features, temp_times] = Calculate_Features(imresize(double(im),0.25),[0,0,0,0,0,0,0,1,0,0]);
    times = times + temp_times;
    features = [features; temp_features];

    [temp_features, temp_times] = Calculate_Features(im,[0,0,0,0,0,0,0,0,1,0]);
    times = times + temp_times;
    features = [features; temp_features];
    [temp_features, temp_times] = Calculate_Features(imresize(double(im),0.5),[0,0,0,0,0,0,0,0,1,0]);
    times = times + temp_times;
    features = [features; temp_features];
    [temp_features, temp_times] = Calculate_Features(imresize(double(im),0.25),[0,0,0,0,0,0,0,0,1,0]);
    times = times + temp_times;
    features = [features; temp_features];

    [temp_features, temp_times] = Calculate_Features(im,[0,0,0,0,0,0,0,0,0,1]);
    times = times + temp_times;
    features = [features; temp_features];

end