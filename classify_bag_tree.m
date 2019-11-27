function[result,accuracy]   = classify_bag_tree(trainFeatures, testFeatures) 

% code for logistic regression. 


[bag_tree_classifier, accuracy] = train_bag_tree(trainFeatures);
% disp('test_features');
testFeatures = testFeatures(:,1:6);
result.classes = bag_tree_classifier.predictFcn(testFeatures);

end