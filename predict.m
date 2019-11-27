function[class]   = predict(testdata, trainFeatures)    


ldaParams = LDA_Train(trainFeatures);     
nbData = size(testdata,1);
nbFeaturesPlus1 = size(testdata,2);
result.output = zeros(nbData,1);
result.classes = zeros(nbData,1);

%classifying the input data
for i=1:size(testdata,1)
        inputVec = testData(i,1:(nbFeaturesPlus1-1))';
        score = ldaParams.a0 + ldaParams.a1N' * inputVec;
        if score >= 0       
           result.classes(i) = ldaParams.classLabels(1);
        else
           result.classes(i) = ldaParams.classLabels(2);
        end        
        result.output(i) = score;
        class{i} = result.classes(i);
end

end
