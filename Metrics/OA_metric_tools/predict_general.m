function prediction = predict_general(images_features,num_images,B,rf)

    prediction = zeros(num_images,1);

    for i = 1:num_images
        s1=regRF_predict(reshape(images_features(i,:), 1,[]),rf{1});

        prediction(i) = [1 s1]*B;
    end

end