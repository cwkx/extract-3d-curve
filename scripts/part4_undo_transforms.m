function [tp] = part4_undo_transforms(p,T,straighten)
%% Undo the various coordinate transforms introduced in the straightening process.
%  Licensed under the GNU General Public License Version 3. 
%  Copyright 2016 Chris G. Willcocks, Durham University, UK.
%
%% Implementation
if (~straighten); tp = p; return; end

xpts = p(1,:) + T{4}(1);                                                    % We need to undo the coordinate space transforms before we can do the inverse transform on the spline points
ypts = p(2,:) + T{5}(1);
temp = xpts;                                                                % Then undo the effects of rot90
xpts = T{1}(2)-T{1}(1) - ypts;
ypts = temp;
xpts = xpts + T{1}(1);                                                      % Then translate the points into the coord space of the original image:
ypts = ypts + T{2}(1);
[xorg, yorg] = tforminv(T{3}, xpts, ypts);
tp(1,:) = xorg(:);                                                          % Inverse transform micro curve back on to original image
tp(2,:) = yorg(:);
tp(3,:) = p(3,:);

end