function[result,accuracy]   = classify_log_reg(trainFeatures, testFeatures) 

% code for logistic regression. 


[log_reg_classifier, accuracy] = train_log_reg(trainFeatures);
% disp('test_features');
testFeatures = testFeatures(:,1:6);
[result.classes, result.score] = log_reg_classifier.predictFcn(testFeatures);
result.score = result.score(:,2);
end