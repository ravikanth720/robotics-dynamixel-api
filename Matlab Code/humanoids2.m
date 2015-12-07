clear all
close all

folder = '/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/'
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, 'PunchFrontal2A.bvh'));

cprobs      = dlmread('/home/amor/Uni/papers/Humanoids2013/data/trainingClassProb_With_High_and_Low3.txt');
jointConfig = dlmread('/home/amor/Uni/papers/Humanoids2013/data/poseData_With_High_and_Low3.txt');
numClusters = size(cprobs,2);

% find for each cluster the corresponding joint angles
nposes = [];
for i = 1:numClusters
    joints = [];
    cluster = cprobs(:,i);
    indices = find(cluster > 0.1);
    joints  = jointConfig(indices,:);
    
    % calculate the covariance
    if length(joints) > 1
        C = cov(joints);
        M = mean(joints);
    else 
        C = [];
        M = [];
    end
    
    % store the
    jassignm(i) = struct('cluster', i, 'joints', joints, 'cov', C, 'mean', M);
    
    % store the number of poses in each cluster
    nposes = [nposes; size(joints,1)];
end

%% draw samples from a cluster
samples = 200;
currCluster = 1;
currCov  = jassignm(currCluster).cov;
currMean = jassignm(currCluster).mean;

nData = mvnrnd(currMean, currCov*2, samples);

figure
plot(nposes);

% extract the joints of agent A and B
mus = [];
sX = 54;
[iCxx, Cyx, condSigma, condMu] = extractIndividualCovariances(currCov, channelsA(1,4:57), currMean(1:sX), currMean(sX+1:end));

for i = 1:size(channelsA,1)
    % extract the individual covariances for each agent
    [condSigma, condMu] = gaussCondition(channelsA(i,4:57), iCxx, Cyx, currMean(1:sX), currMean(sX+1:end));
    mus = [mus condMu];
end

mus = mus';

% add the position information for each agent
agentA  = [zeros(samples, 3) nData(:,1:54)];
agentB  = [zeros(samples, 3) nData(:,55:108)];

agentA(:,1) = -10;

figure
frameLength = 1/3;
bvhVisualize2Skeletons(skelA, agentA, skelA, agentB, frameLength);  

dlmwrite('/heni/sampled.txt', nData, ' ');
