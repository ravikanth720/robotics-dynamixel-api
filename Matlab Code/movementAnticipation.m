clear all;
close all;

testFile = '/heni/interactionmodelsold/data/BVH_RecordingsOnlyRootPositions/PunchesSessionDavidLars/RepelBothArms/PunchesLow1A.bvh'
folder = '/home/amor/Dropbox/milind/MatlabMoCapToolsrevised/InteractionToolbox/data/';

% load the data files that we want to use for training
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, '/bvh/PunchFrontal3A.bvh'));

[sizex sizey]=size(channelsA);
channelsA(:,1:3) = 0;
channelsA = channelsA(1:60, :)

% data set
[params dmps]=learnMotorPrimitive(channelsA');

%create partial data by cutting off some of the data.
[skelB, channelsB, frameLengthB] = bvhReadFile(testFile);
channelsB(:,1:3) = 0;
Partialdata=channelsB(1:40,:);

[Partialdata velocityPartialdata accPartialdata]=getVelAccelMat(Partialdata);
[channelsA velocitychannelsA accchannelsA]=getVelAccelMat(channelsA);
[size1 size2]=size(Partialdata);

% normalize trajectory
normTraj = channelsA; %normalizeTrajectory(velocitychannelsA);
normTest = Partialdata; %normalizeTrajectory(velocityPartialdata);

% estimate the phase
[phase passedPercentage time path] = estimatePhaseDerivative(normTraj, normTest, params, dmps, normTest);

% extract segment
[nlength segment] = extractSegmentFromTrajectory(time, normTraj);

%figure
% extract scales
scales = getScale(segment, normTest);
scales(isnan(scales)) = 1.0;
dmps = scaleDMPs(scales, dmps); 

% estimate the final goal
goals = estimateGoals(params, dmps, passedPercentage, normTraj, velocitychannelsA, accchannelsA, 1);

% the frame in the animation where we are
startFrame = floor(time*size(normTraj, 1));

% reset the number of timesteps to execute
paramsA.timesteps = params.timesteps - startFrame;

% vel + accelerations
vel   = zeros(size(normTest, 2),1)';
accel = zeros(size(normTest, 2),1)';

figure
for i=1:3
    goals(isnan(goals)) = 0;
    % execute motor primitive from estimated phase
    MB = executeMotorPrimitive(params, dmps, normTest(end,:), ...
                                           goals(1, :), ... 
                                           vel, ...
                                           accel, ...
                                           phase);
MB(isnan(MB)) = 0;
bvhVisualize2Skeletons(skelA, MB', skelA, MB', frameLength);
end 

