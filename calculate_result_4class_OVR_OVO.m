function calculate_result_4class_OVR_OVO(sub_no, classifier_name)

folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
result_matrix = cell(nbSubjects,1);
label = [];

% read_data(1:4,3:6)

for l= [1:1:length(name)]
%read_data(1:4,3:6)
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
onlinedata = zeros(1250, 33, nbTrials); 


for k = 1:1:length(RightLift)
    onlinedata(:,:,k) = eval((RightLift{k}))'; 
end
for k = length(RightLift)+1 :1: length(RightLift) + length(LeftLift)
    onlinedata(:,:,k) = eval((LeftLift{k-(length(RightLift))}))'; 
end 
for k = length(RightLift)+length(LeftLift)+1 :1: length(RightLift)+length(LeftLift)+length(RightCln)
    onlinedata(:,:,k) = eval((RightCln{k-length(RightLift)-length(LeftLift)}))'; 
end
for k = (length(RightLift)+length(LeftLift)+length(RightCln)+1):1: nbTrials 
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


result = zeros(nbTrials,13);
i = 0;
j = 0;
accuracy = 0;
trainingTime = zeros(nbTrials,1);
for n = 1:1:nbTrials
    tic;
    result_4class = zeros(1);
    [result_4class, classify] = OVO_OVR_Classification(onlinedata(:,:,n), sub_no, classifier_name);
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
    result(n,12) = classify(10);

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
end
if  strcmp(classifier_name, 'lda')
        save('../RCSP_Toolbox_GPL/result_matrix_lda.mat','result_matrix');
   elseif strcmp(classifier_name, 'svm')
        save('../RCSP_Toolbox_GPL/result_matrix_svm.mat','result_matrix');
    elseif strcmp(classifier_name, 'tree')
        save('../RCSP_Toolbox_GPL/result_matrix_tree.mat','result_matrix');
    else
        disp('classifier not entered');
end
end

