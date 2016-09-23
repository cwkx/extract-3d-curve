function [p] = part3_fitting(B,sigma,d,push)
%% Extract the curve points p from a straightened binary image B, with smoothing sigma, minimum peak distance d, and an edge condition push=true
%  Licensed under the GNU General Public License Version 3. 
%  Copyright 2016 Chris G. Willcocks, Durham University, UK.
%
%% Algorithm 3
c = sum(meshgrid(1:size(B,2), 1:size(B,1)).*B,2) ./ sum(B,2);               % Get centreline
c(isnan(c)) = [];
r = smooth(c, sigma, 'rloess')';                                            % Smooth centerline with robust local regression
[tPosX, tPosY] = findpeaks( r, 'MinPeakDistance', d);                       % Find positive and negative peaks
[tNegX, tNegY] = findpeaks(-r, 'MinPeakDistance', d);
tNegX=-tNegX;
if push                                                                     % Extend peaks to boundary of objects
    tPosX = max(meshgrid(1:size(B,2), 1:size(B,1)).*B,[],2);
    tPosX = tPosX(tPosY)';
    tNegX = min(meshgrid(1:size(B,2), 1:size(B,1)).*(1./B),[],2);
    tNegX = tNegX(tNegY)';
end
t = [[c(1), tPosX, tNegX, c(end)]', [1, tPosY, tNegY, sum(any(B,2))]'];     % Implementation robustness issue: handle matlab peak edge cases (add peaks to start and end)
t = sortrows(t, 2);
m = imfilter(t(:,2), [0;0.5;0.5], 'symmetric');                             % Create midpoints
m = m(1:(end-1));                                                           % Since there are n-1 midpoints in n data points
m = [interp1(1:length(r), r, m), m];                                        % Adding x-coordinates
mz = imfilter(t(:,1), [0;-0.5;0.5], 'symmetric');                           % Create midpoint depth
mz = mz(1:(end-1));
m = [m, mz];                                                                % Adding z-coordinates
t = [t, zeros(size(t,1),1)];
p = [t; m];
p = sortrows(p, 2)';
p(isnan(p))=0;
p(3,:,:) = -p(3,:,:);                                                       % Flip the curve depth sign like this (see future work in paper)

end