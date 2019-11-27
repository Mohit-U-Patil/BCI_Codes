
%load the sqeezenet

sq_net = squeezenet;

%layers
layers = sq_net.Layers;

%modify the layers 
layers(23) = fullyConnectedLayer(5);
layers(25) = classificationLayer;


% loading the training and testing data
[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');

%training options
opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);

%reading the training images?
trainingImages.ReadFcn = @readFunctionTrain;

%train the net
myNet = trainNetwork(trainingImages, layers, opts);

testImages.ReadFcn = @readFunctionTrain;

%make predictions
predictedLabels = classify(myNet, testImages);

%obtain accuracy
accuracy = mean(predictedLabels == testImages.Labels)