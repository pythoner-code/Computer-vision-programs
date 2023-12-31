curlingImg = imread("curlingImage.jpg");
curlingMask = segmentImage(curlingImg);
function [BW,maskedImage] = segmentImage(X)

curlingImg = X;
X = im2gray(curlingImg);
X = imadjust(X);
BW = im2gray(X) > 80;
radius = 22;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);
BW = imcomplement(BW);
maskedImage = X;
maskedImage(~BW) = 0;
imshow(maskedImage)
end
