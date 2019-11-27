function[result,accuracy]   = classify_tree(trainFeatures, testFeatures) 

% code for bag of trees. the two hardcoded parameters are : 
% MaxNumSplits : 799
% NumLearningCycles : 30

%For any help
% if (tired) : 
%     call me;
% else
%     https://in.mathworks.com/help/stats/treebagger.html;

[treeclassifier, accuracy] = train_tree(trainFeatures);
% disp('test_features');
testFeatures = testFeatures(:,1:6);
result.classes = treeclassifier.predictFcn(testFeatures);

end