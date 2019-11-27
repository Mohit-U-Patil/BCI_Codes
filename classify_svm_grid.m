function[result,accuracy]   = classify_svm_grid(trainFeatures, testFeatures) 
%This is not final so dont shout xD 
% The dimension of the input data is (nbDataPoint, 1+2nfb), i.e. (n, 7)
% This is the script to train a gaussian SVM classifier hyperparameters:

%kernel_function = 'gaussian';
% kernel_scale = 'auto';
% box_constraint = '1';
% polynomial_order = [];
% kernel_offset = [];
% solver = [];
% outlier_fraction = [];
% remove_duplicates = 'True';

%Hyperparamater is optimized by optimize_hyperparameter
%Using 'bayesopt';Bayesian optimization. Internally, this setting calls bayesopt.


%the radial basis function (RBF) kernel is used as the kernel function of SVMs. 
%There are two parameters related with this kernel: σ and γ. 
%The upper bound σ for penalty term and kernel parameter γ plays a critical role in performance of SVMs.
%Hence, inappropriate selection of parameters σ and γ, may cause over-fitting or under-fitting problem. 
%Therefore, we should find optimal σ and γ so that the classifier can accurately classify the data input. 
%In this work, we use 5-fold cross-validation to investigate the appropriate kernel parameter σ, and γ.
%Principally, all the pairs of (σ, γ) for RBF kernel are tried and the one with the best cross-validation accuracy is selected.
%After the selection of optimal kernel parameters σ, and γ, the whole training data was trained once more to construct the final classifier.
%Link : https://www.sciencedirect.com/science/article/pii/S0957417410005695

optimize_hyperparameters = 'auto';

% kernel_function = 'gaussian';
% kernel_scale = 'auto';
% box_constraint = '1';
% polynomial_order = [];
% kernel_offset = [];
% solver = [];
outlier_fraction = 0.05;
remove_duplicates = 'off';

[svmclassifier, accuracy] = train_svm_grid(trainFeatures, outlier_fraction, remove_duplicates, optimize_hyperparameters );
testFeatures = testFeatures(:,1:6);
result.classes = svmclassifier.predictFcn(testFeatures);
end