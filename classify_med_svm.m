function[result,accuracy]   = classify_med_svm(trainFeatures, testFeatures) 

% code for logistic regression. 


[med_svm_classifier, accuracy] = train_med_svm(trainFeatures);
% disp('test_features');
testFeatures = testFeatures(:,1:6);
result.classes = med_svm_classifier.predictFcn(testFeatures);

end