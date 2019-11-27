function[result,accuracy]   = classify_logistic_reg_reg(trainFeatures, testFeatures) 


B1 = train_logistic_reg_reg(trainFeatures);
X_test = testFeatures(:,1:6);
result = glmval(B1,X_test,'logit');

end