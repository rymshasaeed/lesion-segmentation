clc, clearvars, close all

% Prompt user to select breast ultrasound image
[filename, path] = uigetfile('Images\Breast image\*.png');

% Read the ultrasound image and ground truth
img = imread(fullfile(path, filename));
GT = imread(fullfile('Images\Mask image', ['mask_', filename(12:end-4), '.png']));

% Convert the original image to grayscale if it is an rgb image
if size(img,3) > 1
    I = uint8(rgb2gray(img));
else
    I = uint8(img);
end

% Resize the image to 128x128
I = imresize(I, [128 128]);

% Get global threshold
T = threshold(I);

% Preprocessing
[I_pre, local_T] = preprocess(I, T);

% Perform segmentation based on region growing algorithm
I_seg = RegionGrowing(I_pre, local_T);

% Postprocessing
I_seg = postprocess(I_seg);

% Jaccard similarity score
[idx, dist] = jaccard_coefficient(double(GT), I_seg);

% Display results
figure;
subplot(1,4,1)
imshow(img, []), title('Original image')
subplot(1,4,2)
imshow(I_seg, []), title('Segmented lesion')
subplot(1,4,3)
imshow(GT, []), title('Ground truth')
subplot(1,4,4)
imshowpair(I_seg, GT), title({'Comparsion', ['Jaccard index: ', num2str(idx*100), '%']})

% Write segmentation results to local directory
if ~exist('Segmentation Results', 'dir')
    mkdir('Segmentation Results')
end
imwrite(double(I_seg), fullfile('Segmentation Results', ['lesion_' filename(12:end-4) '.jpg']));
