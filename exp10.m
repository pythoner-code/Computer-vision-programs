filename = "shaky_car.avi";
hVideoSource = VideoReader(filename);
hTM = vision.TemplateMatcher("ROIInputPort", true, ...
"BestMatchNeighborhoodOutputPort", true);
hVideoOut = vision.VideoPlayer("Name", "Video Stabilization");
hVideoOut.Position(1) = round(0.4*hVideoOut.Position(1));
hVideoOut.Position(2) = round(1.5*(hVideoOut.Position(2)));
hVideoOut.Position(3:4) = [650 350];
pos.template_orig = [109 100];
pos.template_size = [22 18];
pos.search_border = [15 10];
pos.template_center = floor((pos.template_size-1)/2);
pos.template_center_pos = (pos.template_orig + pos.template_center - 1);
W = hVideoSource.Width;
H = hVideoSource.Height;
BorderCols = [1:pos.search_border(1)+4 W-pos.search_border(1)+4:W];
BorderRows = [1:pos.search_border(2)+4 H-pos.search_border(2)+4:H];
sz = [W, H];
TargetRowIndices = ...pos.template_orig(2)-1:pos.template_orig(2)+pos.template_size(2)-2;
TargetColIndices = ...
pos.template_orig(1)-1:pos.template_orig(1)+pos.template_size(1)-2;
SearchRegion = pos.template_orig - pos.search_border - 1;
Offset = [0 0];

Target = zeros(18,22);
firstTime = true;
while hasFrame(hVideoSource)
input = im2gray(im2double(readFrame(hVideoSource)));
if firstTime
Idx = int32(pos.template_center_pos);
MotionVector = [0 0];
firstTime = false;
else
IdxPrev = Idx;
ROI = [SearchRegion, pos.template_size+2*pos.search_border];
Idx = hTM(input,Target,ROI);
MotionVector = double(Idx-IdxPrev); end
[Offset, SearchRegion] = updatesearch(sz, MotionVector, ...
SearchRegion, Offset, pos);
Stabilized = imtranslate(input, Offset, "linear");
Target = Stabilized(TargetRowIndices, TargetColIndices);
Stabilized(:, BorderCols) = 0;
Stabilized(BorderRows, :) = 0;
TargetRect = [pos.template_orig-Offset, pos.template_size];
SearchRegionRect = [SearchRegion, pos.template_size + 2*pos.search_border];
input = insertShape(input, "rectangle", [TargetRect; SearchRegionRect],...
"ShapeColor", "white");
txt = sprintf("(%+05.1f,%+05.1f)", Offset);
input = insertText(input(:,:,1),[191 215],txt,"FontSize",16, ...
"FontColor", "white", "BoxOpacity", 0);
hVideoOut([input(:,:,1) Stabilized]);
end
