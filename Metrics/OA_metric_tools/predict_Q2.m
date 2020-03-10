function prediction = predict_Q2(images_features,num_images,B,rf)

    indexes = {1,2,3,4,[5,9,13,17],[6,10,14,18],[7,11,15,19],[8,12,16,20],...
        [21,23,25,27,29,31,33],[22,24,26,28,30,32,34],[35,37,39,41,43,45],[36,38,40,42,44,46],...
        47,48,49,50,...
    [51,55,53,63],[52,56,60,64],[53,57,61,65],[54,58,62,66],[67,69,71,73,75,77,79],...
    [68,70,72,74,76,78,80],[81,83,85,87,89,91],[82,84,86,88,90,92],93,94,95,96,...
    [97,101,105,109],[98,102,106,110],[99,103,107,111],[100,104,108,112],...
    [113,115,117,119,121,123,125],[114,116,118,120,124,126],[127,129,131,133,135,137],...
    [128,130,132,134,136,138],139,140,141,142,143,144,145,146,147,148,149,150,...
    151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,...
    [166:177],[178:183],[184:195],[196:210],[211:235],[236:260],...
    [261:285],...
    286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306};

%     selected_features_Q1 = [5,7,11,16,18,19,28,30,31,44,49,58,65,88,3,1,72];
    
    indexG1 = [11,12,18,30];
    featsG1 = [];
    for n = 1:length(indexG1)
        featsG1 = [featsG1 indexes{indexG1(n)}];
    end
    
%     indexG2 = [18,30];
%     featsG2 = [];
%     for n = 1:length(indexG2)
%         featsG2 = [featsG2 indexes{indexG2(n)}];
%     end
    
    indexG3 = [69];
    featsG3 = [];
    for n = 1:length(indexG3)
        featsG3 = [featsG3 indexes{indexG3(n)}];
    end
    
    indexG4 = [27,26,25,15,3,75,49,40,41,45,47,63,48,57,39,56,84,83,77,80,79,85,82,78,91,90,89,81];
    featsG4 = [];
    for n = 1:length(indexG4)
        featsG4 = [featsG4 indexes{indexG4(n)}];
    end

    
%     addpath('Functions/MY','Functions/MY/external/matlabPyrTools','Functions/MY/external/randomforest-matlab/RF_Reg_C')
    
    prediction = zeros(num_images,1);

    for i = 1:num_images
%         s1=regRF_predict(reshape(images_features(i,1:18), 1,[]),rf{1});
%         s2=regRF_predict(reshape(images_features(i,19:63), 1,[]),rf{2});
%         s3=regRF_predict(reshape(images_features(i,64:138), 1,[]),rf{3});

        s1=regRF_predict(reshape(images_features(i,featsG1), 1,[]),rf{1});
        s2=regRF_predict(reshape(images_features(i,featsG4), 1,[]),rf{2});
        s3=regRF_predict(reshape(images_features(i,featsG3), 1,[]),rf{3});
%         s4=regRF_predict(reshape(images_features(i,featsG4), 1,[]),rf{4});

        prediction(i) = [1 s1 s2 s3]*B;
    end

end