function prediction = predict_MY(images_features,num_images,B,rf)
    
%     addpath('Functions/MY','Functions/MY/external/matlabPyrTools','Functions/MY/external/randomforest-matlab/RF_Reg_C')

    temp = [1,2,6,5,9,8];
    temp = [temp,temp+9*ones(1,6),temp+18*ones(1,6)];
    
    prediction = zeros(num_images,1);

    for i = 1:num_images

        s1=regRF_predict(reshape(images_features(i,temp), 1,[]),rf{1});
        s2=regRF_predict(reshape(images_features(i,28:72), 1,[]),rf{2});
        s3=regRF_predict(reshape(images_features(i,73:147), 1,[]),rf{3});

        prediction(i) = [1 s1 s2 s3]*B;
    end

end