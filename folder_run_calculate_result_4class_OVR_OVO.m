function folder_run_calculate_result_4class_OVR_OVO(classifier_name, algo_name, ch2keep, nfb, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)
% function folder_run_calculate_result_4class_OVR_OVO(classifier_name, ch2keep, nfb, low, high, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent')
% decomposition_level = 6 ;
% denoising_method = 'SURE' ; 
% ThresholdRule = 'Soft';
% NoiseEstimate = 'LevelIndependent';
folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
result_matrix = cell(nbSubjects,1);

read_data_and_denoise(1:4,ch2keep, 8, 30, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent');

for l= [1:1:length(name)]
 label = [];
 disp('Analyzing file:');
 name(l)
 stepwise_classification_features(algo_name,ch2keep, nfb,l,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
 sub_no = l;
%read_data(1:4,ch2keep)
 load(cell2mat(name(l)));   
 matObj = matfile(cell2mat(name(l)));
 RightLift = who(matObj, 'RightImg*');
 LeftLift = who(matObj, 'LeftImg*'); 
 RightCln = who(matObj, 'RightclenchImg*');
 LeftCln = who(matObj, 'LeftclenchImg*');
 nbChannels = 32;
 segmentLength = 5;
 fs = 250;


 for k=1:length(RightLift)
   label = vertcat(label, 1);
 end
 for k=1:length(LeftLift)
   label = vertcat(label, 2);
 end
 for k=1:length(RightCln)
   label = vertcat(label, 3);
 end
 for k=1:length(LeftCln)
   label = vertcat(label, 4);
 end 
 
nbTrials = length(label);
disp('nbTrials');
    nbTrials
onlinedata = zeros(1250, 33, nbTrials); 


for k = 1:1:length(RightLift)
    
%     disp('RightLift length');
%     k-(length(RightLift))
    
    onlinedata(:,:,k) = eval((RightLift{k}))'; 
end
for k = length(RightLift)+1 :1: length(RightLift) + length(LeftLift)
    
%     disp('LeftLift length');
%     k-(length(RightLift))    
    
    onlinedata(:,:,k) = eval((LeftLift{k-(length(RightLift))}))'; 
end 
for k = length(RightLift)+length(LeftLift)+1 :1: length(RightLift)+length(LeftLift)+length(RightCln)
    
%     disp('RightCln length');
%     k-length(RightLift)-length(LeftLift)
    
    onlinedata(:,:,k) = eval((RightCln{k-length(RightLift)-length(LeftLift)}))'; 
end
for k = (length(RightLift)+length(LeftLift)+length(RightCln)+1):1: nbTrials 
    
%     disp('onlinedata:');
%     onlinedata(:,:,k)
%     disp('nbTrials');
%     nbTrials
%     disp('LeftCln length');
%     k-length(RightLift)-length(LeftLift)-length(RightCln)
    
    onlinedata(:,:,k) = eval((LeftCln{k-length(RightLift)-length(LeftLift)-length(RightCln)}))'; 
end 


save('../RCSP_Toolbox_GPL/onlinedata.mat','onlinedata');   

%in four class classification, multiple class training signal is causing
%problems, error is CSP can be used with only 2 classes. Following block
%changes allEEGSignals into EEGSignals12,
%EEGSignals13,EEGSignals14,EEGSignals23,EEGSignals24,EEGSignals34. after
%this before calling online_csp inside Pair_4class, allEEGSignals will be
%replaced by one of the 6 EEGSignal combinations respectively before the
%call so multiclass issue is solved.


result = zeros(nbTrials,22);
i = 0;
j = 0;
accuracy = 0;
trainingTime = zeros(nbTrials,1);
for n = 1:1:nbTrials
    tic;
    result_4class = zeros(1);
    [result_4class, classify] = OVO_OVR_Classification(onlinexedata(:,:,n), sub_no, ch2keep, classifier_name, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
    result(n,1) = label(n);%true class
    result(n,2) = result_4class(1);
    result(n,3) = classify(1);%6 predictions of OVO for 4 classes
    result(n,4) = classify(2);
    result(n,5) = classify(3);
    result(n,6) = classify(4);
    result(n,7) = classify(5);
    result(n,8) = classify(6);
    result(n,9) = classify(7);%4 predictions of OVR for 4 classes
    result(n,10) = classify(8);
    result(n,11) = classify(9);
    result(n,12) = classify(10); %result(n,13) is the main accuracy
    result(n,14) = classify(11);
    result(n,15) = classify(12);
    result(n,16) = classify(13); % direction-action classification result
    result(n,17) = classify(14); % action-direction classification result
    result(n,18) = classify(15); % block 2 classification result
    result(n,19) = classify(16); % block 3 classification result
    result(n,20) = classify(17); % block 4 classification result
    result(n,21) = classify(18); % block 5 classification result
    result(n,22) = classify(19); % block 6 classification result
    if result(n,1) == result(n,2)
        i = i + 1;
    else
        j = j + 1;
   %result(n,2) = results.labels;
    end
    accuracy = i/(i+j);
    result(n,13) = accuracy;
    trainingTime(n) = toc;
end
trainingTime;

%saving the results to the appropriate matlab files
aa = who(matObj);
clear(aa{:})
% delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');
% delete ('..\RCSP_Toolbox_GPL\allEEGSignals_bak.mat');
% delete ('..\RCSP_Toolbox_GPL\name.mat');
% delete ('..\RCSP_Toolbox_GPL\onlinedata.mat');
% delete ('..\RCSP_Toolbox_GPL\testingEEGSignals.mat');
% delete ('..\RCSP_Toolbox_GPL\trainingEEGSignals.mat');
result_matrix{l} = result;
delete('../RCSP_Toolbox_GPL/trainFeatures.mat');
delete('../RCSP_Toolbox_GPL/onlinedata.mat');
delete('../RCSP_Toolbox_GPL/CSPMatrix.mat');
end

file_name = strcat('../RCSP_Toolbox_GPL/result_matrix',classifier_name, algo_name, '.mat');
save(file_name,'result_matrix');
%     if strcmp(classifier_name, 'lda')
%         save('../RCSP_Toolbox_GPL/result_matrix_lda.mat','result_matrix');
%     elseif strcmp(classifier_name, 'RLDA')
%         save('../RCSP_Toolbox_GPL/result_matrix_RLDA.mat','result_matrix');
%     elseif strcmp(classifier_name, 'svm')
%         save('../RCSP_Toolbox_GPL/result_matrix_svm.mat','result_matrix');
%     elseif strcmp(classifier_name, 'tree')
%         save('../RCSP_Toolbox_GPL/result_matrix_tree.mat','result_matrix');
%     elseif strcmp(classifier_name, 'log_reg')
%         if strcmp(algo_name, 'CSP_JointDiag')
%             save('../RCSP_Toolbox_GPL/result_matrix_log_reg_CSP_JointDiag.mat','result_matrix');
%         elseif strcmp(algo_name, 'DL_CSP_auto')
%             save('../RCSP_Toolbox_GPL/result_matrix_DL_CSP_Auto.mat','result_matrix');
%         elseif strcmp(algo_name, 'DL_CSP_diff')
%             save('../RCSP_Toolbox_GPL/result_matrix_DL_CSP_diff.mat','result_matrix');
%         elseif strcmp(algo_name, 'DL_CSP')
%             save('../RCSP_Toolbox_GPL/result_matrix_DL_CSP.mat','result_matrix');
%         elseif strcmp(algo_name, 'TR_CSP')
%             save('../RCSP_Toolbox_GPL/result_matrix_TR_CSP.mat','result_matrix'); 
%         elseif strcmp(algo_name, 'DL_TR_CSP')
%             save('../RCSP_Toolbox_GPL/result_matrix_DL_TR_CSP.mat','result_matrix');  
%         end
%     elseif strcmp(classifier_name, 'lin_svm')
%         save('../RCSP_Toolbox_GPL/result_matrix_lin_svm.mat','result_matrix');
%     elseif strcmp(classifier_name, 'med_svm')
%         save('../RCSP_Toolbox_GPL/result_matrix_med_svm.mat','result_matrix');
%     elseif strcmp(classifier_name, 'bag_tree')
%         save('../RCSP_Toolbox_GPL/result_matrix_bag_tree.mat','result_matrix');
%    
%     else
%         disp('classifier not entered');
%     end
    
%     nbSubjects = 29;
    disp('Hierarchial classification accuracies');
    accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        size_of_result = size(result_matrix{n});
        accu_print(n,1) = n;
        accu_print(n,2) = result_matrix{n}(size_of_result(1),13);
    end    
    accu_print
    
    
%     nbSubjects = 29;
    disp('Direction-Action accuracy');
    AD_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,16)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        AD_accuracy = i/(i+j);
        AD_accu_print(n,1) = n;
        AD_accu_print(n,2) = AD_accuracy;
    end
    AD_accu_print
    
    disp('Action-direction accuracy');
    DA_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,17)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        DA_accuracy = i/(i+j);
        DA_accu_print(n,1) = n;
        DA_accu_print(n,2) = DA_accuracy;
    end
    DA_accu_print
    
    disp('Block 2 accuracy');
    B2_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,18)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        B2_accuracy = i/(i+j);
        B2_accu_print(n,1) = n;
        B2_accu_print(n,2) = B2_accuracy;
    end
    B2_accu_print
    
    disp('Block 3 accuracy');
    B3_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,19)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        B3_accuracy = i/(i+j);
        B3_accu_print(n,1) = n;
        B3_accu_print(n,2) = B3_accuracy;
    end
    B3_accu_print
    
    disp('Block 4 accuracy');
    B4_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,20)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        B4_accuracy = i/(i+j);
        B4_accu_print(n,1) = n;
        B4_accu_print(n,2) = B4_accuracy;
    end
    B4_accu_print
    
    disp('Block 5 accuracy');
    B5_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,21)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        B5_accuracy = i/(i+j);
        B5_accu_print(n,1) = n;
        B5_accu_print(n,2) = B5_accuracy;
    end
    B5_accu_print

    disp('Block 6 accuracy');
    B6_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
                if result(k,1) == result(k,22)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
        end
        
        B6_accuracy = i/(i+j);
        B6_accu_print(n,1) = n;
        B6_accu_print(n,2) = B6_accuracy;
    end
    B6_accu_print
    
    disp('Right-Left  accuracy');
    LR_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
            if ismember(result(k,1),[1 3])
                if result(k,14) == 9
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
                
            elseif ismember(result(k,1),[2 4])
                if result(k,14) == 10
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
            end
        end
        LR_accuracy = i/(i+j);
        LR_accu_print(n,1) = n;
        LR_accu_print(n,2) = LR_accuracy;
    end
    LR_accu_print
    
    
    disp('Lift-Clench accuracy');
    LC_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
            if ismember(result(k,1),[1 2])
                if result(k,15) == 11
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
            
            elseif ismember(result(k,1),[3 4])
                if result(k,15) == 12
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
            end
        end
        LC_accuracy = i/(i+j);
        LC_accu_print(n,1) = n;
        LC_accu_print(n,2) = LC_accuracy;
    end    
    LC_accu_print
    
    disp('Right Lift vs Right Clench accuracy');
    RLRC_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
            if ismember(result(k,1),[1 3])
                if result(k,1) == result(k,4)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
            end
        end
        RLRC_accuracy = i/(i+j);
        RLRC_accu_print(n,1) = n;
        RLRC_accu_print(n,2) = RLRC_accuracy;
    end    
    RLRC_accu_print
    
    disp('Left Lift vs Left Clench accuracy');
    LLLC_accu_print = zeros(nbSubjects,2);
    for n = 1:1:nbSubjects
        i = 0;
        j = 0;
        result = result_matrix{n};
        size_of_result = size(result_matrix{n});
        for k = 1:1:size_of_result(1)
            if ismember(result(k,1),[2 4])
                if result(k,1) == result(k,7)
                    i = i + 1;
                else
                    j = j + 1;
                 %result(n,2) = results.labels;
                end
            end
        end
        LLLC_accuracy = i/(i+j);
        LLLC_accu_print(n,1) = n;
        LLLC_accu_print(n,2) = LLLC_accuracy;
    end    
    LLLC_accu_print
    
    
    
end

