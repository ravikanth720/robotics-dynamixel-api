function [phase passedPercentage time path] = estimatePhase(params, dmps, testPattern, mapping)

% get the two movements
movAgentA = params.trainingdata;

% project to low dimensional space if necessary
if nargin > 3 
    movAgentB = out_of_sample(testPattern, mapping);
else
    movAgentB = testPattern;
end

% matrix of frame distances
cost = getDistanceMatrix(movAgentA, movAgentB);

% call dynamic time warop
[dist, path, D, time] = dtw(cost, 0);
    
% the passed time in percent
passedPercentage = floor(time*100);
    
% the current phase
if passedPercentage == 0
    passedPercentage = 1;
end
phase = dmps(1).C(passedPercentage);