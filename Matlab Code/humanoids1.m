cprobs      = dlmread('/home/amor/Uni/papers/Humanoids2013/data/reaching_trainingClassProb.txt');
jointConfig = dlmread('/home/amor/Uni/papers/Humanoids2013/data/wholeTrainingReaching.txt');
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
    nposes = [nposes; length(joints)];
end

%% draw samples from a cluster
samples = 200;
currCluster = 15;
currCov  = jassignm(currCluster).cov;
currMean = jassignm(currCluster).mean;

nData = mvnrnd(currMean, currCov*5.0, samples);

figure
plot(nposes);

dlmwrite('/heni/sampled.txt', nData, ' ');
