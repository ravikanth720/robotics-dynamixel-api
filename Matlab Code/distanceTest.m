clear all
echo off

lag = 3;
dims = 3;
numStates = 4;
visual = 1;
error = [];

folder = '/Users/grendizer/Documents/MATLAB/ICRA';

% load the data files that we want to use for training
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, '/bvh/PunchesLeftRight2A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder,'/bvh/PunchFrontal3A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder, '/bvh/PunchFrontal4A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder,'/bvh/RightHook3A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder, '/bvh/RightHook2A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder,'/bvh/FrontKick1A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder, '/bvh/FrontKick2A.bvh'));

[skelB, channelsB, frameLengthB] = bvhReadFile(strcat(folder,'/bvh/PunchesLeftRight2B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/bvh/PunchFrontal3B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/bvh/PunchFrontal4B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/bvh/RightHook3B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/bvh/RightHook2B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/bvh/FrontKick1B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/bvh/FrontKick2B.bvh'));

if visual == 1
    frameLength = 1/25;
    bvhVisualize2Skeletons(skelB, channelsA, skelA, channelsB, frameLength);  
end

% remove positions
channelsA(:,1:6) = 0;
channelsB(:,1:6) = 0;

% fix positions to the first value
channelsA = removeBvhPositions(skelA,channelsA);
channelsB = removeBvhPositions(skelB,channelsB);

% now embedd A into its temporal context
% and revise B accordingly
[sX sY] = size(channelsB);

channelsA  = temporalEmbedding(channelsA,lag);
channelsB  = temporalEmbedding(channelsB,lag);

% matrix of frame distances
dist = getDistanceMatrix(channelsA, channelsB);

% plot the distance matrix
figure;
imagesc(dist);

% cluster using gmm
channelsC = [channelsA; channelsB];

opts = statset('Display','final');
[idx,prototypes] = kmeans(channelsC,numStates,'Distance','sqEuclidean','Replicates',20,'Options',opts);
                
% cluster with gaussians                
%gm = gmdistribution.fit(channelsC,2,'Options',opts);
%idx = cluster(gm,channelsC);

%calculate transition matrix from cluster assingments
trans = calculateTransitionMatrix(idx, numStates, 0)

%plot the transition matrix
figure;
imagesc(trans);

%error = [error; []] ;
%end
%dlmwrite('errorRecBPCA.txt', error)