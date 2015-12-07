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

frameLength = 1/25;
bvhVisualize2Skeletons(skelB, channelsA, skelA, channelsB, frameLength)