imageFolder = '/MATLAB Drive/Computer Vision for Engineering and Science/Images';
imds = imageDatastore(imageFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
bag = bagOfFeatures(imds);
histograms = encode(bag, imds);
splitRatio = 0.8; 
numImages = numel(imds.Files);
if numImages == 0
  error('Error: No images found in the dataset folder.');
else
  idx = randperm(numImages);
  splitPoint = round(splitRatio * numImages);

  if splitPoint < numImages
    trainingIdx = idx(1:splitPoint);
    testIdx = idx(splitPoint+1:end);
    imdsTrain = subset(imds, trainingIdx);
    imdsTest = subset(imds, testIdx);
    SVMModel = fitcecoc(histograms(trainingIdx, :), imdsTrain.Labels);
    predictedLabels = predict(SVMModel, histograms(testIdx, :));
    actualLabels = imdsTest.Labels;
    accuracy = sum(predictedLabels == actualLabels)/ numel(predictedLabels);
    disp(['Accuracy: ' num2str(accuracy)]);
  else
    disp('Error: SplitPoint exceeds the number of dataset elements.');
  end
end
