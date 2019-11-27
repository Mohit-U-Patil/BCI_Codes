%this function is not an independent function. Has to be called from the
%classification script
function [result,accuracy]  = stepwise_classification_classifiers(amp_data_collect,true_class, CSPMatrix, trainFeatures, ch2keep,low,high,mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name)
%WTR CSP From Fabian lotte RCSP toolbox%
%MI classification onlineby MOPA and Nickcool %
order = 5;
nbFilterPairs = 3;
nbChannels = length(ch2keep);
channelList = {(ch2keep)};
EEGdataOnline.c = channelList;
EEGdataOnline.s = 250;
EEGdataOnline.y = zeros(1,1);
EEGdataOnline.x = zeros(1250, nbChannels, 1);

    EEGdataOnline.y = true_class ; %todo:insert the true label here;
    EEGdataOnline.x = amp_data_collect(:, ch2keep ,1); %todo:insert the data here%(1250, nbChannels, 1);
    %assigning the true label here
    %filtering the data
    EEGdataOnline = eegButterFilter(EEGdataOnline, low, high, order);
%     EEGdataOnline = denoise_eeg_wavelet(EEGdataOnline, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
    EEGdataOnline.x;
    
    %extracting test features
    testFeatures = extractCSPFeatures(EEGdataOnline, CSPMatrix, nbFilterPairs);
    %training a LDA classifier on these features & classifying the test features with the learnt LDA
    if strcmp(classifier_name, 'lda')
        [result,accuracy] =  classify(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'RLDA')
        [result,accuracy] =  classify_RLDA(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'svm_grid')
        [result,accuracy] =  classify_svm_grid(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'svm_bayes')
        [result,accuracy] =  classify_svm_bayes(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'tree')
        [result,accuracy] =  classify_tree(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'log_reg')
        [result,accuracy] =  classify_log_reg(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'lin_svm')
        [result,accuracy] =  classify_lin_svm(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'med_svm')
        [result,accuracy] =  classify_med_svm(trainFeatures, testFeatures);
    elseif strcmp(classifier_name, 'bag_tree')
        [result,accuracy] =  classify_bag_tree(trainFeatures, testFeatures);
   
    else
        disp('classifier not entered');
    end
    %find out the output of the classifier ar this point {i}
    %disp(['EEG_data_online.x dimension' num2str(size(EEGdataOnline.x))]);
    %output = predict(testFeatures,trainFeatures);
    %%print the output and accuracy here 
end
