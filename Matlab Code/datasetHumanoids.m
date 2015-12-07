clear all;
close all;

folder = '/Users/grendizer/Documents/MATLAB/ICRA';
folder = '/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/';

dims   = 3;
visual = 0;
cutoff = 60;
ncut = 60;

% load the data files that we want to use for training
[skelA, channelsA, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow1A.bvh');
channelsA = channelsA(1:cutoff,:);

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh1A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchRight1A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh2A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow1A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow2A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow3A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

[skelB, channelsB, frameLength] = bvhReadFile('/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchRight1A.bvh');
channelsA = [channelsA; channelsB(1:cutoff,:)];

%channelsA = appendMotion(channelsA, strcat(folder, '/bvh/PunchFrontal4A.bvh'));
%channelsA = appendMotion(channelsA, strcat(folder, '/bvh/PunchFrontal5A.bvh'));
channelsA(:,1:6) = 0;
channelsA = channelsA;

frameLength = 1/25;
figure
if visual == 1
    bvhVisualize2Skeletons(skelA, channelsA, skelA, channelsA, frameLength)
end

% remove zero columns
%channelsA(:, find(sum(abs(channelsA)) < 1)) = []; 
%channelsA = channelsA - repmat(mean(channelsA), size(channelsA, 1), 1);

% reduce dimensionality of data set% learn one big pca space
[mappedData, mapping] = compute_mapping(channelsA, 'PCA',dims);

% plot the low-dimensional coordinates
figure
scatter(mappedData(:,1), mappedData(:,2));
figure
plot3(mappedData(:,1), mappedData(:,2), mappedData(:,3));

%%% 
%% Learning Phase
% learn a latent motor primitive for our data set
[skelA, trainingData, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow1A.bvh');
trainingData = trainingData(1:ncut,:);

[params dmps] = learnLatentMotorPrimitive(trainingData, mapping);
trainingDataProj= out_of_sample(trainingData,mapping);

%%%
%% Initial Execution Phase
% execute latent motor primitive
start = out_of_sample(trainingData(1,   :),mapping);
goal  = [-50.1739  30.5018  0]
vel   = [0 0 0]; 
accel = [0 0 0];
phase = 1.0;
MA = executeLatentMotorPrimitive(params, dmps, start, goal, vel, accel, phase, mapping);

%%% 
%% Testing Phase with New Data
% load test set
[skelA, testData, frameLength] = bvhReadFile('/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow3A.bvh');
testData    = testData(1:ncut,:);
testDataProj= out_of_sample(testData,mapping);

% estimate the phase of a new movement
% I still don't have the scale in here
[phase passedPercentage time path] = estimatePhase(params, dmps, testData, mapping);

[sx sy] = size(testDataProj);
goals = estimateGoals(params, dmps, passedPercentage, testDataProj, zeros(sx,sy), zeros(sx,sy), 1);

figure
goal = goals(end,:);
MA = executeLatentMotorPrimitive(params, dmps, start, goal, vel, accel, phase, mapping);
if visual == 1
    bvhVisualize2Skeletons(skelA, MA, skelA, MA, frameLength);
end

%%%
%% Analysis
figure
hold on
plot(mappedData(:,1), 'b');
plot(trainingDataProj(:,1), 'r');