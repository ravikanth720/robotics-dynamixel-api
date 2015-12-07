clear all;
close all;

% params
dims = 7;
project = 1;
visual = 0;
numFrames = 30;

%%%
%% Getting the data
%%%
folder = '/Users/grendizer/Documents/MATLAB/ICRA';

% load the data files that we want to use for training
[skelA, channelsA, frameLength]  = bvhReadFile(strcat(folder,'/bvh/WaveLeft1B.bvh'));
[skelB, channelsB, frameLengthB] = bvhReadFile(strcat(folder,'/bvh/WaveLeft2B.bvh'));

[skelC, channelsTest, frameLengthB] = bvhReadFile(strcat(folder,'/bvh/WaveLeft3B.bvh'));

% visualize animation
if visual == 1
    frameLength = 1/25;
    bvhVisualize2Skeletons(skelB, channelsA, skelA, channelsB, frameLength);  
end


% remove positions
channelsA(:,1:6) = 0;
channelsB(:,1:6) = 0;
channelsTest(:,1:6) = 0;

% fix positions to the first value
channelsA    = removeBvhPositions(skelA,channelsA);
channelsB    = removeBvhPositions(skelB,channelsB);
channelsTest = removeBvhPositions(skelB,channelsB);

% concatenate data
channelsC = [channelsA; channelsB];
[sX sY] = size(channelsA);

% project to lower dimensional space
if project == 1
    % learn one big pca space
    [mappedX, mapping] = compute_mapping(channelsC, 'PCA',dims);
end

%%%
%% Learning the Motor Primitive
%%%

% learn motor primtive
[paramsA dmpsA] = learnLatentMotorPrimitive(channelsA, mapping);
[paramsB dmpsB] = learnLatentMotorPrimitive(channelsB, mapping);

% cut down the number of frames
channelsTest = channelsTest(1:numFrames,:);

[phase passedPercentage time path] = estimatephase(paramsA, dmpsA, channelsTest, mapping);
 
% project new data down
projTest = out_of_sample(channelsTest, mapping);

timesteps = paramsA.timesteps;

for k = 1:10
    
% estimate the final goal
for i = 1:dims
    % get the velocities and accelerations of each trajectory
    [x dx ddx] = getVelAccel(projTest(:,i));
    % estimate
    goals = estimateGoals(paramsA, dmpsA(i), passedPercentage, x, dx, ddx, 0);
    goal(i) = goals(end);
end

% the frame in the animation where we are
startFrame = floor(time*length(channelsA));

% reset the number of timesteps to execute
paramsA.timesteps = timesteps - startFrame;

% calculate start position
latentStart = projTest(end,:);
    
% execute motor primitive from estimated phase
MC = executeLatentMotorPrimitive(paramsA, dmpsA, ... 
                                           latentStart, ...
                                           goal, ... 
                                           zeros(1, dims), ...
                                           zeros(1, dims), ...
                                           phase, ...
                                           mapping);

% add the position
repB = MC;
repB(:,2) = -5;
channelsTest(:,2) = -5;
repB(:,4) = -90;
channelsTest(:,4) = -90;
% plot observed part

%bvhVisualize2Skeletons(skelB, channelsTest, skelA, channelsTest, frameLength); 

% plot prediction
bvhVisualize2Skeletons(skelB, [channelsTest; repB], skelA, [channelsTest; repB], frameLength*1);  

end