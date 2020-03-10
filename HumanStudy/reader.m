clear

score_name = {'2.mat','3.mat','4.mat','5.mat','6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat','14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat','22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat','30.mat','31.mat','32.mat','33.mat','34.mat','35.mat','36.mat','37.mat','39.mat','40.mat','41.mat','42.mat','43.mat','44.mat','45.mat'};

load('addresses.mat','addresses')

num_im = length(addresses);

scores = zeros(length(score_name),num_im);

for r = 1:length(score_name)
    
    load(['HumanScores/',score_name{r}],'quality')
    
    % First Column: Index of the image
    % Second Column: Score given by the subject
    % Other columns was information related with the conditions of the room
    quality = quality(:,1:2);
    
    % Saving the score in the proper order
    % Each row in 'score' are the scores from the same subject
    % Each column in 'score' are the scores given to the same image
    for n = 1:num_im
        scores(r,quality(n,1)) = quality(n,2);
    end
    
end

zScores = zeros(size(scores));

for n = 1:size(scores,1)
    
    mu = mean(scores(n,:));
    s = std(scores(n,:));
    
    for m = 1:size(scores,2)
        zScores(n,m) = (scores(n,m)-mu)/s;
    end
    
end

zScoresNormPrev = 100*(zScores+3)/6;

kScores = zeros(size(scores,2),1);
meanScores = zeros(size(scores,2),1);
stdScores = zeros(size(scores,2),1);

for n = 1:num_im
    kScores(n) = kurtosis(zScores(:,n));
    meanScores(n) = mean(zScores(:,n));
    stdScores(n) = std(zScores(:,n));
end

countersP = zeros(size(scores,1),1);
countersQ = zeros(size(scores,1),1);

% Rejection Procedure
for n = 1:num_im
    for i = 1:size(scores,1)
        if kScores(n) <= 4 && kScores(n) >= 2
            if zScores(i,n) >= meanScores(n) + stdScores(n)*2;
                countersP(i) = countersP(i) + 1;
            elseif zScores(i,n) <= meanScores(n) - stdScores(n)*2;
                countersQ(i) = countersQ(i) + 1;
            end
        else
            if zScores(i,n) >= meanScores(n) + stdScores(n)*4.47;
                countersP(i) = countersP(i) + 1;
            elseif zScores(i,n) <= meanScores(n) - stdScores(n)*4.47;
                countersQ(i) = countersQ(i) + 1;
            end
        end
    end
end

index = [];

for n = 1:size(scores,1)
    if (countersP(n)+countersQ(n))/608 <= 0.05
        index = [index n];
    end
end

% recalculation of zScores
scores = scores(index,:);
zScores = zeros(size(scores));

for n = 1:size(scores,1)
    
    mu = mean(scores(n,:));
    s = std(scores(n,:));
    
    for m = 1:num_im
        zScores(n,m) = (scores(n,m)-mu)/s;
    end
    
end

% Final Scores for the images in SRIJ
zScoresNorm = 100*(zScores+3)/6;

% Getting only the super resolved images
hScoresSRIJ = mean(zScoresNorm(:,[1:96 129:640]));

% human scores for the ground truth
HDScoresSRIJ = mean(zScoresNorm(:,97:128));
