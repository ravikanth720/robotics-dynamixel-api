% Test Gaussian Conditioning considering the influence of the two last
% poses of A on the next pose of Agent B

clear;

%%%%%%%%%%%%%%%%% read needed files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% HighLowKick %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[foo trainingPosesA1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickA1.bvh');
[foo trainingPosesA2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickA2.bvh');
[foo trainingPosesA3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickA3.bvh');
[foo trainingPosesA4 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickA4.bvh');
[foo trainingPosesA5 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickA5.bvh');

[foo trainingPosesB1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickB1.bvh');
[foo trainingPosesB2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickB2.bvh');
[foo trainingPosesB3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickB3.bvh');
[foo trainingPosesB4 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickB4.bvh');
[foo trainingPosesB5 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickB5.bvh');

[foo, testPosesA, bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickA6.bvh');
[skelB, realTestPosesB, frameLengthB] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/HighLowKick/lowKicks/HighLowKickB6.bvh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% read needed files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% PunchesLowLeft %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [foo trainingPosesA1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft1A.bvh');
% [foo trainingPosesA2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft2A.bvh');
% [foo trainingPosesA3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft3A.bvh');
% 
% [foo trainingPosesB1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft1B.bvh');
% [foo trainingPosesB2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft2B.bvh');
% [foo trainingPosesB3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft3B.bvh');
% 
% [foo, testPosesA, bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft4A.bvh');
% [skelB, realTestPosesB, frameLengthB] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLowLeft4B.bvh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% read needed files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% PunchesLow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [foo trainingPosesA1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow1A.bvh');
% [foo trainingPosesA2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow2A.bvh');
% [foo trainingPosesA3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow3A.bvh');
% 
% [foo trainingPosesB1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow1B.bvh');
% [foo trainingPosesB2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow2B.bvh');
% [foo trainingPosesB3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow3B.bvh');
% 
% [foo, testPosesA, bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow4A.bvh');
% [skelB, realTestPosesB, frameLengthB] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow4B.bvh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% read needed files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% PunchesRight %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [foo trainingPosesA1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight1A.bvh');
% [foo trainingPosesA2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight2A.bvh');
% [foo trainingPosesA3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight3A.bvh');
% [foo trainingPosesA4 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight4A.bvh');
% 
% [foo trainingPosesB1 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight1B.bvh');
% [foo trainingPosesB2 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight2B.bvh');
% [foo trainingPosesB3 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight3B.bvh');
% [foo trainingPosesB4 bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight4B.bvh');
% 
% [foo, testPosesA, bar] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight5A.bvh');
% [skelB, realTestPosesB, frameLengthB] = bvhReadFile('../../data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelSingleArm/PunchesRight5B.bvh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% eliminate first three columns, that represent positions. We work only
% with joint angles.
trainingPosesA1 = trainingPosesA1(:,4:end);
trainingPosesA2 = trainingPosesA2(:,4:end);
trainingPosesA3 = trainingPosesA3(:,4:end);
trainingPosesA4 = trainingPosesA4(:,4:end);
trainingPosesA5 = trainingPosesA5(:,4:end);

%%%%% NORMALIZATION %%%%%%%
trainingPosesA1 = mod(trainingPosesA1, 360);
trainingPosesA2 = mod(trainingPosesA2, 360);
trainingPosesA3 = mod(trainingPosesA3, 360);
trainingPosesA4 = mod(trainingPosesA4, 360);
trainingPosesA5 = mod(trainingPosesA5, 360);
%%%%%%%%%%%%%%%%%%%%%%%%%%%

velocitiesA1 = trainingPosesA1(2:end,:) - trainingPosesA1(1:end-1,:);
velocitiesA2 = trainingPosesA2(2:end,:) - trainingPosesA2(1:end-1,:);
velocitiesA3 = trainingPosesA3(2:end,:) - trainingPosesA3(1:end-1,:);
velocitiesA4 = trainingPosesA4(2:end,:) - trainingPosesA4(1:end-1,:);
velocitiesA5 = trainingPosesA5(2:end,:) - trainingPosesA5(1:end-1,:);

trainingPosesA1 = [trainingPosesA1(2:end,:) velocitiesA1];
trainingPosesA2 = [trainingPosesA2(2:end,:) velocitiesA2];
trainingPosesA3 = [trainingPosesA3(2:end,:) velocitiesA3];
trainingPosesA4 = [trainingPosesA4(2:end,:) velocitiesA4];
trainingPosesA5 = [trainingPosesA5(2:end,:) velocitiesA5];




trainingPosesB1 = trainingPosesB1(:,4:end);
trainingPosesB2 = trainingPosesB2(:,4:end);
trainingPosesB3 = trainingPosesB3(:,4:end);
trainingPosesB4 = trainingPosesB4(:,4:end);
trainingPosesB5 = trainingPosesB5(:,4:end);

velocitiesB1 = trainingPosesB1(2:end,:) - trainingPosesB1(1:end-1,:);
velocitiesB2 = trainingPosesB2(2:end,:) - trainingPosesB2(1:end-1,:);
velocitiesB3 = trainingPosesB3(2:end,:) - trainingPosesB3(1:end-1,:);
velocitiesB4 = trainingPosesB4(2:end,:) - trainingPosesB4(1:end-1,:);
velocitiesB5 = trainingPosesB5(2:end,:) - trainingPosesB5(1:end-1,:);

trainingPosesB1 = [trainingPosesB1(2:end,:) velocitiesB1];
trainingPosesB2 = [trainingPosesB2(2:end,:) velocitiesB2];
trainingPosesB3 = [trainingPosesB3(2:end,:) velocitiesB3];
trainingPosesB4 = [trainingPosesB4(2:end,:) velocitiesB4];
trainingPosesB5 = [trainingPosesB5(2:end,:) velocitiesB5];






testPosesA = testPosesA(:,4:end);

%%%%% NORMALIZATION %%%%%%%
testPosesA = mod(testPosesA, 360);
%%%%%%%%%%%%%%%%%%%%%%%%%%%

testVelocitiesA = testPosesA(2:end,:) - testPosesA(1:end-1,:);

testPosesA = [testPosesA(2:end,:) testVelocitiesA];




trainingPosesA_first = [trainingPosesA1(1:end-2,:); trainingPosesA2(1:end-2,:); trainingPosesA3(1:end-2,:); trainingPosesA4(1:end-2,:); trainingPosesA5(1:end-2,:)];  % first part of X
trainingPosesA_second = [trainingPosesA1(2:end-1,:); trainingPosesA2(2:end-1,:); trainingPosesA3(2:end-1,:); trainingPosesA4(2:end-1,:); trainingPosesA5(2:end-1,:)];  % second part of X
nextTrainingPosesB = [ trainingPosesB1(3:end,:); trainingPosesB2(3:end,:); trainingPosesB3(3:end,:); trainingPosesB4(3:end,:); trainingPosesB5(3:end,:) ];  % Y

% trainingPosesA_first = [trainingPosesA1(1:end-2,:); trainingPosesA2(1:end-2,:); trainingPosesA3(1:end-2,:)];  % first part of X
% trainingPosesA_second = [trainingPosesA1(2:end-1,:); trainingPosesA2(2:end-1,:); trainingPosesA3(2:end-1,:)];  % second part of X
% nextTrainingPosesB = [ trainingPosesB1(3:end,:); trainingPosesB2(3:end,:); trainingPosesB3(3:end,:)];  % Y

% trainingPosesA_first = [trainingPosesA1(1:end-2,:); trainingPosesA2(1:end-2,:); trainingPosesA3(1:end-2,:); trainingPosesA4(1:end-2,:)];  % first part of X
% trainingPosesA_second = [trainingPosesA1(2:end-1,:); trainingPosesA2(2:end-1,:); trainingPosesA3(2:end-1,:); trainingPosesA4(2:end-1,:)];  % second part of X
% nextTrainingPosesB = [ trainingPosesB1(3:end,:); trainingPosesB2(3:end,:); trainingPosesB3(3:end,:); trainingPosesB4(3:end,:)];  % Y


X = [trainingPosesA_first trainingPosesA_second];

% %%%% NORMALIZATION %%%%%%%
% X = mod(X, 360);
% testPosesA = mod(testPosesA, 360);
% %%%%%%%%%%%%%%%%%%%%%%%%%%

trainingPoses = [X nextTrainingPosesB];


M = size(X,2);

muX = mean(X)';
muY = mean(nextTrainingPosesB)';

bigCovarianceMatrix = cov(trainingPoses);

SigmaXX = bigCovarianceMatrix(1:M,1:M);
SigmaXY = bigCovarianceMatrix(1:M,M+1:end);
SigmaYX = bigCovarianceMatrix(M+1:end,1:M);
SigmaYY = bigCovarianceMatrix(M+1:end,M+1:end);

invSigmaXX = pinv(SigmaXX);

testPosesATransp = testPosesA';
predictedTestPosesB = testPosesATransp*0;

for i = 1:size(testPosesATransp,2)-2
    predictedTestPosesB(:,i+2) = muY + SigmaYX*invSigmaXX*( [testPosesATransp(:,i); testPosesATransp(:,i+1)]-muX );
end
predictedTestPosesB = predictedTestPosesB(:,3:end);

predictedTestPosesB = predictedTestPosesB';
predictedTestPosesB = predictedTestPosesB(:,1:end/2);


% restore the position values and save prediction
r_predictedPoseDataB_testWithGaussianConditioning_2nd_Approach = [realTestPosesB(4:end,1:3) predictedTestPosesB];

bvhWriteFile('../models/r_predictedPoseDataB_testWithGaussianConditioning_2nd_Approach.bvh', skelB, r_predictedPoseDataB_testWithGaussianConditioning_2nd_Approach, frameLengthB);