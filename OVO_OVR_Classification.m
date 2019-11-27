%4 class MI classifier by Nikhil Garg and Mohit Patil using OVO and OVR.
% this is the main classification script, before running the current
% classifier, need to run
% 13th Feb 2019 edit- following algo uses Left vs Right directional
% classification followed by the Lift vs Clench action classification

function [result_4class, classify] =  OVO_OVR_Classification(segment, sub_no, ch2keep, classifier_name, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)
classify = zeros(1,19);
% result_4_class is the direction-action classification
% classify(13) is the action-direction classification

load('allEEGSignals_bak.mat');
load('trainFeatures.mat');
load('CSPMatrix.mat');
allEEGSignals_copy = allEEGSignals_bak ;
rest_count = 0;
OVO_counter = zeros(1,4);
OVO_log_reg_score = zeros(1,4);

 CSPMatrix12 = CSPMatrix{1};
 CSPMatrix13 = CSPMatrix{2};
 CSPMatrix14 = CSPMatrix{3};
 CSPMatrix23 = CSPMatrix{4};
 CSPMatrix24 = CSPMatrix{5} ;
 CSPMatrix34 = CSPMatrix{6};
 CSPMatrix1R = CSPMatrix{7};
 CSPMatrix2R = CSPMatrix{8};
 CSPMatrix3R = CSPMatrix{9};
 CSPMatrix4R = CSPMatrix{10};
 CSPMatrixRL = CSPMatrix{11};
 CSPMatrixLC = CSPMatrix{12};
 
trainFeatures12 = trainFeatures{1} ;
trainFeatures13 = trainFeatures{2} ;
trainFeatures14 = trainFeatures{3} ;
trainFeatures23 = trainFeatures{4} ;
trainFeatures24 = trainFeatures{5} ;
trainFeatures34 = trainFeatures{6} ;
trainFeatures1R = trainFeatures{7} ;
trainFeatures2R = trainFeatures{8} ;
trainFeatures3R = trainFeatures{9} ;
trainFeatures4R = trainFeatures{10} ;
trainFeaturesRL = trainFeatures{11};
trainFeaturesLC = trainFeatures{12};


[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix12, trainFeatures12, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(1) = results.classes;
if (classify(1) == 1)
    OVO_counter(1) = OVO_counter(1) + 1;
elseif (classify(1) == 2)
    OVO_counter(2) = OVO_counter(2) + 1;
end
if (strcmp(classifier_name, 'log_reg'))
    OVO_log_reg_score(1) = OVO_log_reg_score(1) + results.score;
    OVO_log_reg_score(2) = OVO_log_reg_score(2) + (1- results.score);
end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix13, trainFeatures13, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(2) = results.classes;
if (classify(2) == 1)
    OVO_counter(1) = OVO_counter(1) + 1;
elseif (classify(2) == 3)
    OVO_counter(3) = OVO_counter(3) + 1;
end
if (strcmp(classifier_name, 'log_reg'))
    OVO_log_reg_score(1) = OVO_log_reg_score(1) + results.score;
    OVO_log_reg_score(3) = OVO_log_reg_score(3) + (1- results.score);
end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix14, trainFeatures14, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(3) = results.classes;
if (classify(3) == 1)
    OVO_counter(1) = OVO_counter(1) + 1;
elseif (classify(3) == 4)
    OVO_counter(4) = OVO_counter(4) + 1;
end
if (strcmp(classifier_name, 'log_reg'))
    OVO_log_reg_score(1) = OVO_log_reg_score(1) + results.score;
    OVO_log_reg_score(4) = OVO_log_reg_score(4) + (1- results.score);
end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix23, trainFeatures23, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(4) = results.classes;
if (classify(4) == 2)
    OVO_counter(2) = OVO_counter(2) + 1;
elseif (classify(4) == 3)
    OVO_counter(3) = OVO_counter(3) + 1;
end
if (strcmp(classifier_name, 'log_reg'))
    OVO_log_reg_score(2) = OVO_log_reg_score(2) + results.score;
    OVO_log_reg_score(3) = OVO_log_reg_score(3) + (1- results.score);
end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix24, trainFeatures24, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(5) = results.classes;
if (classify(5) == 2)
    OVO_counter(2) = OVO_counter(2) + 1;
elseif (classify(5) == 4)
    OVO_counter(4) = OVO_counter(4) + 1;
end
if (strcmp(classifier_name, 'log_reg'))
    OVO_log_reg_score(2) = OVO_log_reg_score(2) + results.score;
    OVO_log_reg_score(4) = OVO_log_reg_score(4) + (1- results.score);
end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix34, trainFeatures34, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(6) = results.classes;
if (classify(6) == 3)
    OVO_counter(3) = OVO_counter(3) + 1;
elseif (classify(6) == 4)
    OVO_counter(4) = OVO_counter(4) + 1;
end
if (strcmp(classifier_name, 'log_reg'))
    OVO_log_reg_score(3) = OVO_log_reg_score(3) + results.score;
    OVO_log_reg_score(4) = OVO_log_reg_score(4) + (1- results.score);
end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix1R, trainFeatures1R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(7) = results.classes;
if (classify(7) == 5)
    rest_count = rest_count + 1;
elseif (classify(7) == 1)
    OVO_counter(1) = OVO_counter(1) + 1;
end
% if (strcmp(classifier_name, 'log_reg'))
%     OVO_log_reg_score(1) = OVO_log_reg_score(1) + results.score;
% end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix2R, trainFeatures2R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(8) = results.classes;
if (classify(8) == 6)
    rest_count = rest_count + 1;
elseif (classify(8) == 2)
    OVO_counter(2) = OVO_counter(2) + 1;
end
% if (strcmp(classifier_name, 'log_reg'))
%     OVO_log_reg_score(2) = OVO_log_reg_score(2) + results.score;
% end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix3R, trainFeatures3R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(9) = results.classes;
if (classify(9) == 7)
    rest_count = rest_count + 1;
elseif (classify(9) == 3)
    OVO_counter(3) = OVO_counter(3) + 1;
end
% if (strcmp(classifier_name, 'log_reg'))
%     OVO_log_reg_score(3) = OVO_log_reg_score(3) + results.score;
% end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix4R, trainFeatures4R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(10) = results.classes;
if (classify(10) == 8)
    rest_count = rest_count + 1;
elseif (classify(10) == 4)
    OVO_counter(4) = OVO_counter(4) + 1;    
end
% if (strcmp(classifier_name, 'log_reg'))
%     OVO_log_reg_score(4) = OVO_log_reg_score(4) + results.score;
% end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrixRL, trainFeaturesRL, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(11) = results.classes;
if (classify(11) == 9)
     OVO_counter(1) = OVO_counter(1) + 0.5;
     OVO_counter(3) = OVO_counter(3) + 0.5;
elseif (classify(11) == 10)
    OVO_counter(2) = OVO_counter(2) + 0.5;
    OVO_counter(4) = OVO_counter(4) + 0.5;    
else
    disp('invalid classification 1');
end
% if (strcmp(classifier_name, 'log_reg'))
%     OVO_log_reg_score(1) = OVO_log_reg_score(1) + (results.score/2);
%     OVO_log_reg_score(3) = OVO_log_reg_score(3) + (results.score/2);
%     OVO_log_reg_score(2) = OVO_log_reg_score(2) + (1-(results.score/2));
%     OVO_log_reg_score(4) = OVO_log_reg_score(4) + (1-(results.score/2));
% end

[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrixLC, trainFeaturesLC, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
classify(12) = results.classes;
if (classify(12) == 11)
     OVO_counter(1) = OVO_counter(1) + 0.5;
     OVO_counter(2) = OVO_counter(2) + 0.5;
elseif (classify(12) == 12)
    OVO_counter(3) = OVO_counter(3) + 0.5;
    OVO_counter(4) = OVO_counter(4) + 0.5;    
else
    disp('invalid classification 2');
end
% if (strcmp(classifier_name, 'log_reg'))
%     OVO_log_reg_score(1) = OVO_log_reg_score(1) + (results.score/2);
%     OVO_log_reg_score(2) = OVO_log_reg_score(2) + (results.score/2);
%     OVO_log_reg_score(3) = OVO_log_reg_score(3) + (1-(results.score/2));
%     OVO_log_reg_score(4) = OVO_log_reg_score(4) + (1-(results.score/2));
% end

%hierarchial approach
rest_count;
classify;
OVO_counter;
if( rest_count < 4 && rest_count > 1)
    if (rest_count > 2)
        if (classify(7) == 1)
            result_4class = 1;
        elseif (classify(8) == 2)
            result_4class = 2;
        elseif (classify(9) == 3)
            result_4class = 3;
        elseif (classify(10) == 4)
            result_4class = 4;
        end            
    elseif (rest_count == 2)
        if ((classify(7) == 1) && (classify(8) == 2))
            result_4class = classify(1);
        elseif ((classify(7) == 1) && (classify(9) == 3))
            result_4class = classify(2);
        elseif ((classify(7) == 1) && (classify(10) == 4))
            result_4class = classify(3);            
        elseif ((classify(8) == 2) && (classify(9) == 3))
            result_4class = classify(4);    
        elseif ((classify(8) == 2) && (classify(10) == 4))
            result_4class = classify(5);  
        elseif ((classify(9) == 3) && (classify(10) == 4))
            result_4class = classify(6);            
        end
    end 
elseif (OVO_counter(1) == 3)
        result_4class = 1;
elseif (OVO_counter(2) == 3)
        result_4class = 2;
elseif (OVO_counter(3) == 3)
        result_4class = 3;
elseif (OVO_counter(4) == 3)
        result_4class = 4;        
    else

        
        result_4class = 0;
    
end


%following is trial block 1, good accuracy individually but not compound
%accuracy
%direction-action
if classify(11) == 9
    classify(13) = classify(2);
elseif classify(11) == 10
    classify(13) = classify(5);
else
    disp('non valid classification 3');
end

%action-direction
if classify(12) == 11
    classify(14) = classify(1);
elseif classify(12) == 12
    classify(14) = classify(6);
else
    disp('non valid classification 4');
end


% trial block 2
if classify(11) == 9 && classify(12) == 11
    classify(15) = 1;
elseif classify(11) == 9 && classify(12) == 12
    classify(15) = 3;
elseif classify(11) == 10 && classify(12) == 11
    classify(15) = 2;
elseif classify(11) == 10 && classify(12) == 12
    classify(15) = 4;
else
    disp('non valid classification 5');
end

% block 3 - max score
% combined score for all classes out of 12 classifiers
[a, b] = max(OVO_counter);
classify(16) = b;
OVO_counter;

%block 4- max score with Block 1 and Block 2
block_4_counter = zeros(1,4);
if classify(11) == 9 && classify(2) == 1
    block_4_counter(1) = block_4_counter(1) + 1 ;
elseif classify(11) == 9 && classify(2) == 3
    block_4_counter(3) = block_4_counter(3) + 1 ;    
elseif classify(11) == 10 && classify(5) == 2
    block_4_counter(2) = block_4_counter(2) + 1 ;
elseif classify(11) == 10 && classify(5) == 4
    block_4_counter(4) = block_4_counter(4) + 1 ; 
else
    disp('non valid classification 6');
end

if classify(12) == 11 && classify(1) == 1
    block_4_counter(1) = block_4_counter(1) + 1 ;
elseif classify(12) == 11 && classify(1) == 2
    block_4_counter(2) = block_4_counter(2) + 1 ;
elseif classify(12) == 12 && classify(6) == 3
    block_4_counter(3) = block_4_counter(3) + 1 ;
elseif classify(12) == 12 && classify(6) == 4
    block_4_counter(4) = block_4_counter(4) + 1 ;
else
    disp('non valid classification 7');
end

if classify(11) == 9 && classify(12) == 11
     block_4_counter(1) = block_4_counter(1) + 1 ;
elseif classify(11) == 9 && classify(12) == 12
    block_4_counter(3) = block_4_counter(3) + 1 ;
elseif classify(11) == 10 && classify(12) == 11
    block_4_counter(2) = block_4_counter(2) + 1 ;
elseif classify(11) == 10 && classify(12) == 12
    block_4_counter(4) = block_4_counter(4) + 1 ;
else
    disp('non valid classification 8');
end
[a, b] = max(block_4_counter);
classify(17) = b;
block_4_counter;

%block 5- max score with Block1  and Block 2 plus original hierarchial algo
if (strcmp(classifier_name, 'log_reg'))
score_log_reg = zeros(1,4);
[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix1R, trainFeatures1R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
score_log_reg(1) = results.score;
[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix2R, trainFeatures2R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
score_log_reg(2) = results.score;
[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix3R, trainFeatures3R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
score_log_reg(3) = results.score;
[results, ~] = stepwise_classification_classifiers(segment,2, CSPMatrix4R, trainFeatures4R, ch2keep, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate, sub_no, classifier_name);
score_log_reg(4) = results.score;
[val, idx] = max(score_log_reg);
classify(18) = idx;
end

% block 6 - max probability
% combined score for all classes out of 12 classifiers
[a, b] = max(OVO_log_reg_score);
classify(19) = b;

end