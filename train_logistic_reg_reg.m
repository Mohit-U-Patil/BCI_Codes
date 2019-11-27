% Important note : The class of the below classifier should only be 0 or 1.
function [B1] = train_logistic_reg_reg(trainingData)



Y = trainingData(:,7);
X = trainingData(:,1:6);
[B,FitInfo] = newlassoglm(X,Y,'binomial','CV',3);
indx = FitInfo.Index1SE;
cnst = FitInfo.Intercept(indx);
B0 = B(:,indx);
B1 = [cnst;B0];
%preds = glmval(B1,X_test,'logit');

end