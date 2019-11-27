%to_do : feed in filtered and denoised signal in place of
%trainingEEGSignals and testingEEGSignals. 
%why does the code gives error at 10th subject?
folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/subject_matrix';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
acc_table_1 = cell(length(name)+1, 21);
acc_table_2 = cell(length(name)+1, 21);
acc_table_3 = cell(length(name)+1, 17);
acc_table_4 = cell(length(name)+1, 17);
acc_table_5 = cell(length(name)+1, 17);
load('trainingEEGSignals.mat');
load('testingEEGSignals.mat');
for l= [1:1:length(name)]
 
 disp('Analyzing file:');
 name(l)
%Generate a set of trials and estimate the riemannian mean 
% generate a set of trials , 5 channels, 100 time sample and 1000 trials
%X = randn(5,100,1000);
% reshaping the matrix as per the toolbox
trainingEEGSignals_formatted = permute(trainingEEGSignals{l}.x,[2 1 3]);
testingEEGSignals_formatted = permute(testingEEGSignals{l}.x,[2 1 3]) ; 
X_train = trainingEEGSignals_formatted;
X_test =  testingEEGSignals_formatted;

Ytrain  = trainingEEGSignals{l}.y';
trueYtest  = testingEEGSignals{l}.y';

% covariance matrix of each trial
COVtrain = covariances(X_train);
COVtest = covariances(X_test);
% Riemannian mean
C_train = mean_covariances(COVtrain,'riemann');
C_test = mean_covariances(COVtest,'riemann');

% COVtest = data.data(:,:,data.idxTest);
% COVtrain = data.data(:,:,data.idxTraining);

% #### Classification
% Example of motor imagery classification
% File data/MotorImagery.mat contain preprocessed data from the subject A09
% from the BCI competition IV, dataset IIa.
% Applied preprocessing step are : 
% 
%   - frequency filtering between 8 and 30 Hz (5-th order butterworth)
%   - time based epoching between 3.5 to 5.5 s after the cue
%   - sample covariance estimation
%
% Classification is trained on training data (epoch index 1:288) and
% applied on test data (epoch index 289:576). Results are evaluated in
% terms of classification accuracy.

% Data formating
% COVtest = data.data(:,:,data.idxTest);
% trueYtest  = data.labels(data.idxTest);
% 
% COVtrain = data.data(:,:,data.idxTraining);
% Ytrain  = data.labels(data.idxTraining);


%%Calculate the distances

% metric_mean = {'euclid','logeuclid','riemann','ld'};
% metric_dist = {'euclid','logeuclid','riemann','ld','kullback'};
% dist = zeros(length(metric_mean),length(metric_dist));
% 
% for i=1:length(metric_mean)
%     for j=1:length(metric_dist)
%         [~, dist(i,j)] = mdm(COVtest,COVtrain,Ytrain,metric_mean{i},metric_dist{j});
%     end
% end
% 
% disp('------------------------------------------------------------------');
% disp('Distances Rows : distance metric, Colums : mean metric');
% disp('------------------------------------------------------------------');
% displaytable(dist',metric_mean,10,{'.1f'},metric_dist)
% disp('------------------------------------------------------------------');


%% MDM classification - Multiclass
metric_mean = {'euclid','logeuclid','riemann','ld'};
metric_dist = {'euclid','logeuclid','riemann','ld','kullback'};
acc = zeros(length(metric_mean),length(metric_dist));
acc_table_1(l+1,1) = name(l);
count = 2;
for i=1:length(metric_mean)
    for j=1:length(metric_dist)
        Ytest = mdm(COVtest,COVtrain,Ytrain,metric_mean{i},metric_dist{j});
        acc(i,j) = 100*mean(Ytest==trueYtest);
        acc_table_1(1, count) = {strcat(metric_mean{i}, metric_dist{j})};
        acc_table_1(l+1,count) = {acc(i,j)};
        count = count+1;
    end
end

disp('------------------------------------------------------------------');
disp('Accuracy (%) - Rows : distance metric, Colums : mean metric MDM classification - Multiclass');
disp('------------------------------------------------------------------');
displaytable(acc',metric_mean,10,{'.1f'},metric_dist)
disp('------------------------------------------------------------------');

%% Discriminant geodesic filtering + MDM classification - Multiclass
metric_mean = {'euclid','logeuclid','riemann','ld'};
metric_dist = {'euclid','logeuclid','riemann','ld','kullback'};
acc = zeros(length(metric_mean),length(metric_dist));
acc_table_2(l+1,1) = name(l);
count = 2;
for i=1:length(metric_mean)
    for j=1:length(metric_dist)
        Ytest = fgmdm(COVtest,COVtrain,Ytrain,metric_mean{i},metric_dist{j});
        acc(i,j) = 100*mean(Ytest==trueYtest);
        acc_table_2(1, count) = {strcat(metric_mean{i}, metric_dist{j})};
        acc_table_2(l+1,count) = {acc(i,j)};
        count = count+1;
    end
end
disp('------------------------------------------------------------------');
disp('Accuracy (%) - Rows : distance metric, Colums : mean metric Discriminant geodesic filtering + MDM classification - Multiclass');
disp('------------------------------------------------------------------');
displaytable(acc',metric_mean,10,{'.1f'},metric_dist)
disp('------------------------------------------------------------------');

%% MDM classification - Binary case
metric_mean = 'riemann';
metric_dist = 'riemann';
acc = diag(nan(4,1));
acc_table_3(l+1,1) = name(l);
count = 2;
for i=1:4
    for j=i+1:4
        % Select the trials
        ixtrain = (Ytrain==i)|(Ytrain==j);
        ixtest = (trueYtest==i)|(trueYtest==j);
        % Classification
        Ytest = mdm(COVtest(:,:,ixtest),COVtrain(:,:,ixtrain),Ytrain(ixtrain),metric_mean,metric_dist);
        % Accuracy
        acc(i,j) = 100*mean(Ytest==trueYtest(ixtest));
        acc_table_3(1, count) = {count};
        acc_table_3(l+1,count) = {acc(i,j)};
        count = count+1;
    end
end

disp('------------------------------------------------------------------');
disp('Accuracy (%) - Rows/Colums : Couple of classes MDM classification - Binary case');
disp('------------------------------------------------------------------');
displaytable(acc'+acc,{'Right Lift','Left Lift','Right Clench','Left Clench'},10,{'.1f'},{'Right Lift','Left Lift','Right Clench','Left Clench'})
disp('------------------------------------------------------------------');

%% Discriminant geodesic filtering + MDM Classification - Binary case
metric_mean = 'riemann';
metric_dist = 'riemann';
acc = diag(nan(4,1));
acc_table_4(l+1,1) = name(l);
count = 2;
for i=1:4
    for j=i+1:4
        % Select the trials
        ixtrain = (Ytrain==i)|(Ytrain==j);
        ixtest = (trueYtest==i)|(trueYtest==j);
        % Classification
        Ytest = fgmdm(COVtest(:,:,ixtest),COVtrain(:,:,ixtrain),Ytrain(ixtrain),metric_mean,metric_dist);
        % Accuracy
        acc(i,j) = 100*mean(Ytest==trueYtest(ixtest));
        acc_table_4(1, count) = {count};
        acc_table_4(l+1,count) = {acc(i,j)};
        count = count+1;
    end
end

disp('------------------------------------------------------------------');
disp('Accuracy (%) - Rows/Colums : Couple of classes Discriminant geodesic filtering + MDM Classification - Binary case');
disp('------------------------------------------------------------------');
displaytable(acc'+acc,{'Right Lift','Left Lift','Right Clench','Left Clench'},10,{'.1f'},{'Right Lift','Left Lift','Right Clench','Left Clench'})
disp('------------------------------------------------------------------');

%% Kmeans usupervised Classification - Binary case
metric_mean = 'riemann';
metric_dist = 'riemann';
acc = diag(nan(4,1));
acc_table_4(l+1,1) = name(l);
count = 2;
% for each couple of classes
for i=1:4
    for j=i+1:4
        % Select the trials
        ixtrain = (Ytrain==i)|(Ytrain==j);
        ixtest = (trueYtest==i)|(trueYtest==j);
        % Classification
        Ytest = kmeanscov(COVtest(:,:,ixtest),COVtrain(:,:,ixtrain),2,metric_mean,metric_dist);
        % Find the right labels
        Classes = unique(trueYtest(ixtest));
        truelabels = (trueYtest(ixtest) == Classes(1))+1;
        % Accuracy
        acc(i,j) = 100*mean(Ytest==truelabels);
        acc_table_4(1, count) = {count};
        acc_table_4(l+1,count) = {acc(i,j)};
        count = count+1;
        if acc(i,j)<50
            acc(i,j) = 100-acc(i,j);
        end
    end
end

disp('------------------------------------------------------------------');
disp('Accuracy (%) - Rows/Colums : Couple of classes Kmeans usupervised Classification - Binary case');
disp('------------------------------------------------------------------');
displaytable(acc'+acc,{'Right Lift','Left Lift','Right Clench','Left Clench'},10,{'.1f'},{'Right Lift','Left Lift','Right Clench','Left Clench'})
disp('------------------------------------------------------------------');

%% Tangent Space LDA Classification - Binary case
% the riemannian metric
metric_mean = 'riemann';
% update tangent space for the test data - necessary if test data corresponds to
% another session. by default 0.
update = 0;
acc = diag(nan(4,1));
acc_table_5(l+1,1) = name(l);
count = 2;
for i=1:4
    for j=i+1:4
        % Select the trials
        ixtrain = (Ytrain==i)|(Ytrain==j);
        ixtest = (trueYtest==i)|(trueYtest==j);
        % Classification
        Ytest = tslda(COVtest(:,:,ixtest),COVtrain(:,:,ixtrain),Ytrain(ixtrain),metric_mean,update);
        % Accuracy
        acc(i,j) = 100*mean(Ytest==trueYtest(ixtest));
        acc_table_5(1, count) = {count};
        acc_table_5(l+1,count) = {acc(i,j)};
        count = count+1;
    end
end

disp('------------------------------------------------------------------');
disp('Accuracy (%) - Rows/Colums : Couple of classes Tangent Space LDA Classification');
disp('------------------------------------------------------------------');
displaytable(acc'+acc,{'Right Lift','Left Lift','Right Clench','Left Clench'},10,{'.1f'},{'Right Lift','Left Lift','Right Clench','Left Clench'})
disp('------------------------------------------------------------------');
end