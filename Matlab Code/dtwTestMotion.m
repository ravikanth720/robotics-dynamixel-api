clear all
close all
echo off

visual = 1;
cutoff = 80;
folder = '/Users/grendizer/Documents/MATLAB/ICRA/bvh/';


% load the data files that we want to use for training
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, 'PunchFrontal2A.bvh'));


[skelB, channelsB, frameLengthB] = bvhReadFile(strcat(folder,'PunchFrontal3A.bvh'));


% make sure the data has same length
[sX sY] = size(channelsA);
if size(channelsB, 1) > sX
    channelsB = channelsB(1:sX,:)
elseif size(channelsA, 1) > size(channelsB, 1)
    channelsA = channelsA(1:size(channelsB, 1),:)
end
    
% visualize motion
if visual == 1
    figure
    frameLength = 1/25;
    bvhVisualize2Skeletons(skelB, channelsA, skelA, channelsB, frameLength);  
end

% Just for testing
channelsB = channelsB(1:cutoff,:)

% fix positions to the first value
X = channelsA;
Y = channelsB;

% matrix of frame distances
cost = getDistanceMatrix(X, Y);

% call dynamic time warp
[dist, path, D, time] = dtw(cost, 1);

% warped Y
wy = Y(fliplr(path(:,2)'), :);
wx = X(fliplr(path(:,1)'), :);


% display animation
if visual == 1
    figure
    frameLength = 1/25;
    bvhVisualize2Skeletons(skelB, wx, skelA, wy, frameLength);  
end

time

%figure
%plot([1:size(wx,2)], wx)
%hold on
%plot([1:size(wy,2)], wy, 'red','LineWidth',2)