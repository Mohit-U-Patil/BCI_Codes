function[result,accuracy]   = classify_lin_svm(trainFeatures, testFeatures) 

% code for logistic regression. 


[lin_svm_classifier, accuracy] = train_lin_svm(trainFeatures);
% disp('test_features');
testFeatures = testFeatures(:,1:6);
result.classes = lin_svm_classifier.predictFcn(testFeatures);

end