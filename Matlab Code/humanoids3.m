clear all
close all

folder = '' %'/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/'
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, '/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh1A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder,'/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh2A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder,'/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh3A.bvh'));

[skelB, channelsB, frameLength] = bvhReadFile(strcat(folder, '/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh1B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh2B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesHigh3B.bvh'));

channelsA(:,1:5) = 0;
channelsB(:,1:5) = 0;

[mappedP, mappingP] = compute_mapping([channelsA; channelsB], 'PCA', 4);
channelsA = out_of_sample(channelsA, mappingP);
channelsB = out_of_sample(channelsB, mappingP);

trainingPoses = [channelsA channelsB];

M = size(channelsA,2);

muX = mean(channelsA)';
muY = mean(channelsB)';

bigCovarianceMatrix = cov(trainingPoses);

SigmaXX = bigCovarianceMatrix(1:M,1:M);
SigmaXY = bigCovarianceMatrix(1:M,M+1:end);
SigmaYX = bigCovarianceMatrix(M+1:end,1:M);
SigmaYY = bigCovarianceMatrix(M+1:end,M+1:end);

invSigmaXX = pinv(SigmaXX);

testPosesATransp = channelsA';
predicted = [];

[skelC, channelsC, frameLength] = bvhReadFile('/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchRight1A.bvh');
channelsC(:,1:5) = 0;
channelsC = out_of_sample(channelsC, mappingP);

for i = 1:size(channelsC, 1);
    conditioned = muY + SigmaYX*invSigmaXX*( channelsC(i,:)' - muX ); 
    predicted   = [predicted conditioned]; 
end

%predicted = predicted';


figure
frameLength = 1/20;
channelsC = reconstruct_data(channelsC, mappingP);
predicted = reconstruct_data(predicted', mappingP);
predicted(:,1:5) = 0;
bvhVisualize2Skeletons(skelC, channelsC, skelB, predicted, frameLength);  

%dlmwrite('/heni/sampled.txt', nData, ' ');
