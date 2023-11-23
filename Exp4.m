movingImage = imread("/MATLAB Drive/Computer Vision for Engineering and Science/Data/MathWorks Images/Rt9Frame1.png");
fixedImage = imrotate(movingImage,90);
imshow(movingImage);
cpselect(movingImage, fixedImage);
tform = fitgeotrans(movingPoints2, fixedPoints2, "similarity");
movingImageT = imwarp(movingImage, tform, "OutputView",
imref2d(size(fixedImage)));
montage({fixedImage, movingImageT});
mse = immse(fixedImage, movingImageT);
ssimValue = ssim(fixedImage, movingImageT);
fprintf('MSE between movingImg and fixedImg: %.4f\n', mse);
fprintf('SSIM between movingImg and fixedImg: %.4f\n', ssimValue);
