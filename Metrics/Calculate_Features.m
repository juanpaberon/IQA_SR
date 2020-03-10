function [features times] = Calculate_Features(im_ori,argument)

    %% ini
    
    % MSCN, PP, PLD, SP, DCT, GSM, PC, KurSke, Sigma, DoG
    times = zeros(1,10);

    features = [];

    im = double(im_ori);

    structdis = calculate_mscn(im);
    vec = structdis(:);
    
    %% MSCN
    if argument(1) == 1
        tic
        [f1, betal, betar] = estimateaggdparam_ILNIQE(vec);
        f2 = (betal+betar)/2;

        [leftshape, leftstd] = estimateGGDParamGoodall(vec(vec<0));
        [rightshape, rightstd] = estimateGGDParamGoodall(vec(vec>0));
        %f3 shape difference
        f3 = rightshape - leftshape;
        %f4 standard deviation difference
        f4 = rightstd - leftstd;

        features = [features; f1; f2; f3; f4];
        times(1) = toc;
    end
    
    %% PP
    
    if argument(2) == 1
        tic
        % paired product coefficients
        shifts = [0 1; 1 0; 1 1; 1 -1];

        for itr_shift = 1:4
            % circular shift coefficients to calculate pair products
            shifted_structdis = circshift(structdis,shifts(itr_shift,:));
            % calculate pair products
            pair = structdis(:).*shifted_structdis(:);
            % calculate pair product features: 
            % pp1 shape, pp2 mean of distribution, pp3 leftstd, pp4 rightstd,
            [pp1, pp2, ~, ~, pp3, pp4] = estimateAGGDParamGoodall(pair);
            features = [features;pp1;pp2;pp3;pp4];
        end
        times(2) = toc;
    end

    
    %% PLD
    
    if argument(3) == 1
        tic
        % calculate log coefficients
        logderdis = log(abs(structdis) + 0.1);

        for itr_shift = 1:4
            % circular shift to log coefficients to calculate first 4 log
            % derivative coefficients
            shifted_logderdis = circshift(logderdis,shifts(itr_shift,:));
            % calculate log derivative coefficients
            pair = shifted_logderdis(:) - logderdis(:);
            % calculate log der features
            %pd1 shape, pd2 standard deviation
    %         [pd1, pd2] = estimateGGDParamGoodall(pair);
            [pd1, betal, betar] = estimateaggdparam_ILNIQE(pair);
            pd2 = (betal+betar)/2;
            features = [features;pd1;pd2];
        end

        shift1 = [-1 0; 0 0; -1 -1];
        shift2 = [1 0; 1 1; 1 1];
        shift3 = [0 -1; 0 1; -1 1];
        shift4 = [0 1; 1 0; 1 -1];
        sign = [-1,1,1];
        for itr_shift = 1:3
            % circular shift to log coefficients to calculate last 3 log
            % derivative coefficients
            shifted_logderdis1 = circshift(logderdis,shift1(itr_shift,:));
            shifted_logderdis2 = circshift(logderdis,shift2(itr_shift,:));
            shifted_logderdis3 = circshift(logderdis,shift3(itr_shift,:));
            shifted_logderdis4 = circshift(logderdis,shift4(itr_shift,:));
            % calculate log derivative coefficients
            pair = shifted_logderdis1(:) + sign(itr_shift).*shifted_logderdis2(:)...
                -shifted_logderdis3(:) -shifted_logderdis4(:);
            %pd1 shape, pd2 standard deviation
    %         [pd1, pd2] = estimateGGDParamGoodall(pair);
            [pd1, betal, betar] = estimateaggdparam_ILNIQE(pair);
            pd2 = (betal+betar)/2;
            features = [features;pd1;pd2];
        end
        times(3) = toc;
    end
    
    %% SP
    
    if argument(4) == 1
        tic
        addpath('FeaturesCalculationTools/matlabPyrTools')

        %parameters of steerable pyramid features
        num_or = 6;
        num_scales = 1;
        %calculate seerable pyramid subbands
        [pyr, pind] = buildSFpyr(im,num_scales,num_or-1);
        [subband, ~] = norm_sender_normalized(pyr,pind,num_scales,num_or,1,1,3,3,50);

        for itr_shift = 1:num_or*num_scales
            %sp1 shape, sp2 standard deviation
    %         [sp1, sp2] = estimateGGDParamGoodall(subband{itr_shift});
            [sp1, betal, betar] = estimateaggdparam_ILNIQE(subband{itr_shift});
            sp2 = (betal+betar)/2;
            features = [features;sp1;sp2];
        end
        times(4) = toc;
    end
    
    %% DCT
    
    if argument(5) == 1
        tic
        im1=im2double(im_ori);

        % Scale factor is 3
        h=fspecial('gaussian',3);
        im_f=double(imfilter(im1,h));
        im2 = im_f(2:2:end,2:2:end);

        h=fspecial('gaussian',3);
        im_f=double(imfilter(im2,h));
        im3 = im_f(2:2:end,2:2:end);

        t1=block_dct(im1);
        t2=block_dct(im2);
        t3=block_dct(im3);

        features = [features; [t1 t2 t3]'];
        times(5) = toc;
    end
    
    %% GSM
    
    if argument(6) == 1
        tic
        addpath('FeaturesCalculationTools/matlabPyrTools')
        
        % Constants
        num_or = 6;
        num_scales = 2;

        f=[];

        [pyr, pind] = buildSFpyr(im,num_scales,num_or-1);
        [subband, size_band] = norm_sender_normalized(pyr,pind,num_scales,num_or,1,1,3,3,50);

        % gama of each subband
        gama_horz = zeros(1,length(subband));
        for ii = 1:length(subband)
            t = subband{ii}; 
            gama_horz(ii) = gama_gen_gauss(t);    
        end
        f = [f, gama_horz];

        % gama across scales
        gama_scale=zeros(1,length(subband)/2);
        for ii = 1:length(subband)/2
            t = [subband{ii}; subband{ii+num_or}];
            gama_scale(ii) = gama_gen_gauss(t);
        end
        f = [f, gama_scale];

        % % global gama across scales 
        % t = cell2mat(subband');
        % gama_global = gama_gen_gauss(t);
        % 
        % f = [f, gama_global];

        % structural correlation between scales
        hp_band = pyrBand(pyr,pind,1);
        cs_val=zeros(1,length(subband));
        for ii = 1:length(subband)
            curr_band = pyrBand(pyr,pind,ii+1);
            [~, ~, cs_val(ii)] = ssim_index_new(imresize(curr_band,size(hp_band)),hp_band);
        end
        f = [f, cs_val];

        % strctural correlation between orientations
        clear cs_val;
        nn = 1; 
        for i = 1:length(subband)/2
            for j = i+1:length(subband)/2
              [~, ~, cs_val(nn)] = ssim_index_new(reshape(subband{i},size_band(i,:)),reshape(subband{j},size_band(j,:)));  
              nn = nn + 1;
            end
        end

        f = [f, cs_val];
        features = [features; f'];
        times(6) = toc;
    end
    
    
    %% PC
    if argument(7) == 1
        tic
        col=im2col(im1,[5 5],'distinct');
        t1=svd(col);
        col=im2col(im2,[5 5],'distinct');
        t2=svd(col);
        col=im2col(im3,[5 5],'distinct');
        t3=svd(col);
        f3=[t1 t2 t3];

        features = [features; f3(:,1); f3(:,2); f3(:,3)];
        times(7) = toc;
    end
    
    %% kurtosis skewness
    
    if argument(8) == 1
        tic
        features = [features; kurtosis(vec); skewness(vec)];
        times(8) = toc;
    end
    
    %% Sigma Map Features
    
    if argument(9) == 1
        tic
        [feat, ~] = sigmaMapFeats(im);
        features = [features; feat'];
        times(9) = toc;
    end
    
    %% DoG Features
    
    if argument(10) == 1
        tic
        feat = DoGFeat(im);
        features = [features; feat'];
        times(10) = toc;
    end
end