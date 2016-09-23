function [B] = guessbg(B)
%% Simple function to guess the foreground/background of objects in a thresholded image
%  Licensed under the GNU General Public License Version 3. 
%  Copyright 2016 Chris G. Willcocks, Durham University, UK.
%
M = ones(size(B));
M(2:end-1,2:end-1) = 0;                                                     % Flip if more than 50% white pixels
if (sum(sum(M & B))/sum(M(:)) > 0.5)                                        % on the image border
    B = ~B;
end
end