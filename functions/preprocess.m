function [y, T] = preprocess(I, T)

% Preprocessing based on contrast value (alpha)
alpha = max(I(:)) - min(I(:));

if alpha<=210 || alpha>=230
    % Apply gamma correction
    y1 = imadjust(I, [], [], 0.2);
    
    % Apply median filter to reduce inherent speckle noise
    y2 = medfilt2(y1, [7 7]);
    
    % Apply histogram equalization
    y3 = histeq(y2);
    
    % Apply thresholding
    y = y3 > T*255;
    
    % Display preprocessing results
    figure;
    subplot(2,3,1), imshow(I), title('Original Image')
    subplot(2,3,2), imshow(y1), title('Gamma Correction')
    subplot(2,3,3), imshow(y2), title('Median Filtering')
    subplot(2,3,4), imshow(y3), title('Histogram Equalization')
    subplot(2,3,5), imshow(y), title('Otsu Thresholding')
    sgtitle('Preprocessing')
else
    % Adjust image contrast
    y1 = imadjust(I, [0 1], [1 0]);
    
    % Gamma correction
    y = imadjust(y1, [], [], 0.9);
    
    % Enhanced threshold 
    T = 50*T;
    
    % Display preprocessing results
    figure;
    subplot(1,3,1), imshow(I), title('Original Image')
    subplot(1,3,2), imshow(y1), title('Contrast Enhancement')
    subplot(1,3,3), imshow(y), title('Gamma Correction')
    sgtitle('Preprocessing')
end