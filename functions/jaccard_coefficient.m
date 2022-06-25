function [idx, dist] = jaccard_coefficient(ground_truth, segmented_img)
% ARGUMENTS:
%           ground_truth - true lesion mask
%           segmented_img - segmented lesion mask
% RETURNS:
%           idx - Jaccard index
%           dist - Jaccard distance

% Intersection image
intersection = ground_truth & segmented_img;

% Union image
union = ground_truth | segmented_img;

% Jaccard index
idx = sum(intersection(:))/sum(union(:));

% Jaccard distance
dist = 1 - idx;

end   