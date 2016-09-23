%  Extracting 3D Parametric Curves from 2D Images of Helical Objects
%  Licensed under the GNU General Public License Version 3. 
%  Copyright 2016 Chris G. Willcocks, Durham University, UK.
clc, clear all, close all;

% Specify an input image here
fprintf('Loading Image... ');
I = imread('leptospira.png');                                               
if (size(I,3) > 1); I = rgb2gray(I); end;                                   fprintf('\tdone!\nSegmenting...');

% Adjust algorithm parameters (see paper for detailed explanations)
straighten  = true;
sigma       = 0.01;             % smoothing amount, try 0.15 for 'licerasiae.png'
d           = max(size(I))/20;  % minimum distance between peaks, set to 0 for images with lots of coils
delta       = 50;
omega       = max(size(I))/20;
omicron     = 30;
push        = true;

% Run our algorithm steps
[c,B]       = part1_segment(I);                                             fprintf('\t\tdone!\nStraightening... ');
[Bp,T]      = part2_straighten(B,c,delta,omega,omicron,straighten);         fprintf('\tdone!\nFitting... ');
[p]         = part3_fitting(Bp,sigma,d,push);                               fprintf('\t\t\tdone!\nUndo transforms... ');
[tp]        = part4_undo_transforms(p,T,straighten);                        fprintf('\tdone!\n');

% Create our cubic spline (cs) through the transformed curve control points tp
cs = cscvn(tp);
cs = fnplotdense(cs);

% We can also use the straight spline (ss) from control points p
ss = cscvn(p);
ss = fnplotdense(ss);

% Example 3D metrics from the straight spline
tortuosity  = sum(sqrt(sum(diff(ss,1,2).^2,1))) / sqrt(sum((ss(:,end) - ss(:,1)).^2));
peaks       = floor(length(p)/2);

% Plot the extracted 3D parametric curve and control points
figure('units','normalized','outerposition',[0 0 1 1]),
h = imshow(I,'InitialMagnification','fit'); set(h,'AlphaData',0.8); hold on;
plot3(tp(1,1:2:end),tp(2,1:2:end),tp(3,1:2:end),'ko', 'MarkerFaceColor', [55,126,184]/255);
plot3(tp(1,2:2:end),tp(2,2:2:end),tp(3,2:2:end),'ko', 'MarkerFaceColor', [77,175,74]/255);
plot3(cs(1,:),cs(2,:),cs(3,:),'-','LineWidth',5,'Color',[228 26 28]/255);
view(3);