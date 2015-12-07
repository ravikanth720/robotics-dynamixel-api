clear all
echo off

lag = 4;
dims = 3;
numStates = 5;
project = 1;
visual = 0;
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
% sX = time
% sy = elements
[sX sY] = size(channelsA);

channelsA  = temporalEmbedding(channelsA,lag);
channelsB  = temporalEmbedding(channelsB,lag);

% concatenate data
channelsC = [channelsA; channelsB];

if project == 1
    % learn one big pca space
    [mappedX, mappingA] = compute_mapping(channelsC, 'PCA',dims);

    % redefine data as its projection
    channelsA = mappedX(1:sX,:);
    channelsB = mappedX(sX+1:end,:);

    % concatenate data
    channelsC = [channelsA; channelsB];
end

% calculate angular velocities of animation
[b,a]=butter(2,.1);
vel = calculateVelocity(channelsA);
vel=filter(b,a,vel);

% plot the projected velocity
figure
plot(linspace(1, size(vel,1), size(vel,1)), vel);

% 
% % matrix of frame distances
% dist = getDistanceMatrix(channelsA, channelsB);
% 
% % plot the distance matrix
% figure;
% imagesc(dist);
% 
% % cluster using kmeans
% opts = statset('Display','final');
% [idx,prototypes] = kmeans(channelsC,numStates,'Distance','sqEuclidean','Replicates',5,'Options',opts);
%                 
% % cluster with gaussians                
% %gm = gmdistribution.fit(channelsC,2,'Options',opts);
% %idx = cluster(gm,channelsC);
% 
% %calculate transition matrix from cluster assingments
% trans = calculateTransitionMatrix(idx, numStates, 0)
% 
% %plot the transition matrix
% figure;
% imagesc(trans);
% 
% %error = [error; []] ;
% %end
% %dlmwrite('errorRecBPCA.txt', error)