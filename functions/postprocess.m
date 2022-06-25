function y = postprocess(I)

% Apply morphological opening and closing  
if sum(I(:)) < 3000
    n = 2;
elseif sum(I(:)) > 5000 && sum(I(:)) < 5500
    n = 6;
elseif sum(I(:)) > 5500 && sum(I(:)) < 5600
    n = 4;
elseif sum(I(:)) > 5600 && sum(I(:)) < 7000
    n = 4;
elseif sum(I(:)) > 7000 && sum(I(:)) < 7500
    n = 9;
elseif sum(I(:)) > 7500 && sum(I(:)) < 8000
    n = 6;
elseif sum(I(:)) > 8000 && sum(I(:)) < 13000
    n = 2;
else
    n = 8;
end
y1 = imopen(I, strel('disk', n));

% Create lesion mask 
mask = imerode(y1, strel('disk', 1));

% Refine segmented image using lesion mask
y2 = y1 - mask;
y3 = imfill(y2, 'holes');
y = imerode(y3, strel('disk', 1));
y = imdilate(y, strel('disk', 4));

% Display postprocessing results
figure;
subplot(2,3,1), imshow(I), title('Segmented image')
subplot(2,3,2), imshow(y1), title('Morphological opening')
subplot(2,3,3), imshow(mask), title('Lesion mask')
subplot(2,3,4), imshow(y2), title('Difference image')
subplot(2,3,5), imshow(y3), title('Fill lesion region')
subplot(2,3,6), imshow(y), title('Erosion follwed by dilation')
sgtitle('Post-processing')

end