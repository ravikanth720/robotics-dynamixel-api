clear all
echo off

lag = 10;
dims = 2;
project = 1;
visual = 1;
cutoff = 60;
folder = '/Users/grendizer/Documents/MATLAB/ICRA';

% load the data files that we want to use for training
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, '/bvh/PunchFrontal4A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder,'/bvh/PunchFrontal3A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder, '/bvh/PunchFrontal4A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder,'/bvh/RightHook3A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder, '/bvh/RightHook2A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder,'/bvh/FrontKick1A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder, '/bvh/FrontKick2A.bvh'));

[skelB, channelsB, frameLengthB] = bvhReadFile(strcat(folder,'/bvh/PunchFrontal3A.bvh'));
%channelsB = appendMotion(channelsB, strcat(folder,'/bvh/PunchFrontal3B.bvh'));
%channelsB = appendMotion(channelsB, strcat(folder,'/bvh/PunchFrontal4B.bvh'));
%channelsB = appendMotion(channelsB, strcat(folder,'/bvh/RightHook3B.bvh'));
%channelsB = appendMotion(channelsB, strcat(folder,'/bvh/RightHook2B.bvh'));
%channelsB = appendMotion(channelsB, strcat(folder,'/bvh/FrontKick1B.bvh'));
%channelsB = appendMotion(channelsB, strcat(folder,'/bvh/FrontKick2B.bvh'));

% make sure the data has same length
[sX sY] = size(channelsA);
if size(channelsB, 1) > sX
    channelsB = channelsB(1:sX,:);
elseif size(channelsA, 1) > size(channelsB, 1)
    channelsA = channelsA(1:size(channelsB, 1),:);
end
    
% visualize motion
if visual == 1
    figure
    frameLength = 1/25;
    bvhVisualize2Skeletons(skelB, channelsA, skelA, channelsB, frameLength);  
end

A = channelsA(lag:end-lag+1,:);
B = channelsB(lag:end-lag+1,:);

channelsA  = temporalEmbedding(channelsA,lag);
channelsB  = temporalEmbedding(channelsB,lag);
channelsC = [channelsA; channelsB];

% concatenate data
[sX sY] = size(channelsA);

if project == 1
    % learn one big pca space
    [mappedX, mappingA] = compute_mapping(channelsC, 'PCA',dims);

    % redefine data as its projection
    X = mappedX(1:sX,:);
    Y = mappedX(sX+1:end,:);

    % concatenate data
    channelsC = [X; Y];
end

% Just for testing
Y = Y(1:cutoff,:)

% matrix of frame distances
cost = getDistanceMatrix(X, Y);

% call dynamic time warop
[dist, path, D, time] = dtw(cost, 1);

% warped Y
wx = A(fliplr(path(:,1)'), :);
wy = B(fliplr(path(:,2)'), :);

% print out the timing
time

% display animation
if visual == 1
    figure
    frameLength = 1/25;
    bvhVisualize2Skeletons(skelB, wx, skelA, wy, frameLength);  
end


%figure
%plot([1:size(wx,2)], wx)
%hold on
%plot([1:size(wy,2)], wy, 'red','LineWidth',2)