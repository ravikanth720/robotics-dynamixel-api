close all;

%folder = '/Users/grendizer/Documents/MATLAB/ICRA';
folder =  '/heni/interactionmodels/data/BVH_RecordingsOnlyRootPositions/'

% load the data files that we want to use for training
[skelA, channelsA, frameLength] = bvhReadFile(strcat(folder, 'PunchesLeftRight2A.bvh'));
channelsA = appendMotion(channelsA, strcat(folder,'PunchFrontal3A.bvh'));

[skelB, channelsB, frameLengthB] = bvhReadFile(strcat(folder,'PunchesLeftRight2B.bvh'));
channelsB = appendMotion(channelsB, strcat(folder,'PunchFrontal3B.bvh'));

frameLength = 1/25;
%bvhVisualize2Skeletons(skelB, channelsA, skelA, channelsB, frameLength)

% calculate correlation
channelsC = [channelsA channelsB];
[r,p] = corrcoef(channelsC)  % Compute sample correlation and p-values.
[i,j] = find(p>0.05);        % Find significant correlations.
[i,j]                        % Display their (row,col) indices.

figure
imagesc(r);

figure
imagesc(p);