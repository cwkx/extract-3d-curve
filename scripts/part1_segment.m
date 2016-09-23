function [c,B] = part1_segment(I)
%% Extract a curve c and binary image B from a greyscale input image of a helical object I.
%  Licensed under the GNU General Public License Version 3. 
%  Copyright 2016 Chris G. Willcocks, Durham University, UK.
%
%  Assumption 1: Object is bright on dark background, otherwise invert.
%                Note: in our implementation, we add a "guessbg" function
%                which attempts to guess this automatically.
%  Assumption 2: Input image is grayscale, otherwise rgb2gray(I), and 2D.
%
%  We return the curve in linear indices.
assert(length(size(I)) == 2);                                               % Input must be 2D greyscale image

%% Algorithm 1
B = guessbg(mat2gray(I)>graythresh(I));                                     % Otsu's thresholding (we also guess the sign to make background black)
B = imfill(B, 'holes');                                                     % Fill holes
C = bwconncomp(B,8);                                                        % Largest component in B
B = bwareaopen(B, max(cellfun(@length,C.PixelIdxList)));
S = bwmorph(B, 'skel', Inf);                                                % Morphological skeleton
s_0 = find(S(:),1,'first');                                                 % Initial seed (any set pixel in S)
D = bwdistgeodesic(S, s_0,'quasi-euclidean');                               % Geodesic distance from s_0
[~, s_1] = max(D(:));                                                       % Seed point 1 (curve start)
D = bwdistgeodesic(S, s_1,'quasi-euclidean');
[~, s_2] = max(D(:));                                                       % Seed point 2 (curve end)
[~, c, ~] = graphshortestpath( ...                                          % Shortest path (8-connectivity)
    im2graph8(~S.*size(D,2).*size(D,1)+1), s_1, s_2);                    

end