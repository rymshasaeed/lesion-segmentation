function y = RegionGrowing(I, T)

% Erode the contrast enhanced image to get a point cloud
y1 = imerode(I, strel('disk', 20,8));

% Apply morphological shrinking to eliminate duplicate seed locations
if numel(y1) == 1
   y2 = y1;
else
    y2 = bwmorph(y1, 'shrink', Inf);
end

% Get seed locations for region growing
seed = I(y2(:));

% Initialize connectivity array
y3 = false(size(I));

% Loop over to find connected regions
for i = 1:length(seed)
    s = seed(i);
    marker = abs(I - s) <= T;
    y3 = y3 | marker;
end

% Obtain contiguous regions corresponding to each seed
if T > 1
    y4 = 1 - bwlabel(imreconstruct(y2, y3));
else
    y4 = marker;
end

% Remove all connected regions that have fewer than 50 pixels
y = bwareaopen(y4, 50);

% Display segmentation results
figure;
subplot(2,3,1), imshow(y1), title('Image erosion')
subplot(2,3,2), imshow(y2), title({'Morphological shrinking', 'to find seed location'})
subplot(2,3,3), imshow(y3), title('Connected regions')
subplot(2,3,4), imshow(y4), title({'Contiguous regions', 'corresponding to each seed'})
subplot(2,3,5), imshow(y), title('Segmented image')
sgtitle('Lesion Segmentation based on region growing')

end