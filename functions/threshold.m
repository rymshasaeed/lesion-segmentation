function T = threshold(I)

% Convert datatype to uint8
I = im2uint8(I(:));

% Get histogram counts for 256 bins
bins = 256;
counts = imhist(I, bins);

% Make counts a double column vector
counts = double(counts(:));

% Find histogram probabilities
P = counts/sum(counts);

% Calculate weight
w = cumsum(P);

% Calculate mean
Mean = cumsum(P .* (1:bins)');

% Calculate variance
var = (Mean(end)*w - Mean).^2./(w.*(1-w));

% Find the index of the maximum value of variance
max_val = max(var);

% The maximum value could be over several bins
% so average together the indices
idx = mean(find(var == max_val));

% Otsu threshold - normalize to the range [0, 1]
T = (idx - 1)/(bins - 1);

end