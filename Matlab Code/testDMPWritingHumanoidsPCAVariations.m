clear all;
close all;

figure
for i = 1:5
    % record a trajectory
    [Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();

    dlmwrite(strcat(strcat('/Users/grendizer/Dropbox/Public/traj', num2str(i)), '.txt'), [Traj Trajy], ' ');
    
    % learn motor primtive
    [paramsA dmpsA] = learnMotorPrimitive([Traj Trajy]');
  
    movModels(i)  = struct('data', [Traj Trajy]', 'dmps', dmpsA);
end

% do pca
[mappedP, mappingP] = dmppca(movModels, 3 , 0);

figure
hold on    
for k = 1:4
    sampledDMPs = sampleDmpFromPca(movModels, mappingP, mappedP);
    
    % execute the dmp
    MA = executeMotorPrimitive(paramsA, movModels(2).dmps, [Traj(1) Trajy(1)], [Traj(end)+randn(1)*0.0 Trajy(end)+randn(1)*0.00], [0 0], [0 0], 1.0);
    plot(MA(1,:), MA(2,:), 'g');
end

dmpsA = movModels(2).dmps;

% record a new partial-trajectory
[Test Testy Testd Testdy Testdd Testddy] = recordTrajectory();

% normalize trajectory
normTraj = normalizeTrajectory([Trajd Trajdy]);
normTest = normalizeTrajectory([Testd Testdy]);

% sampling frm PCA
figure
hold on

plot(Traj, Trajy, 'b', 'LineWidth',1);
plot(Test, Testy, 'g', 'LineWidth',2);

timesteps = paramsA.timesteps;
for k = 1:20
    sampledDMPs = sampleDmpFromPca(movModels, mappingP, mappedP);
    
    % estimate the phase
    [phase passedPercentage time path] = estimatePhaseDerivative(normTraj, normTest, paramsA, sampledDMPs, [Test Testy]);

    % extract segment
    [nlength segment] = extractSegmentFromTrajectory(time, [Traj Trajy]);

    %figure
    % extract scales
    scales = getScale(segment, [Test Testy]);
    sampledDMPs = scaleDMPs(scales, sampledDMPs); 

    % estimate the final goal
    goals = estimateGoals(paramsA, sampledDMPs, passedPercentage, [Test Testy], [Testd Testdy], [Testdd Testddy], 0);

    % the frame in the animation where we are
    startFrame = floor(time*length(Test));

    % reset the number of timesteps to execute
    paramsA.timesteps = timesteps - startFrame;

    % vel + accelerations
    vel   = [Testd(end) Testdy(end)];
    accel = [Testdd(end) Testddy(end)];
    
    % execute motor primitive from estimated phase
    MB = executeMotorPrimitive(paramsA, sampledDMPs, [Test(end) Testy(end)], ...
                                           goals(end, :), ... 
                                           vel, ...
                                           accel, ...
                                           phase);
  
    plot(MB(1,:), MB(2,:), 'r', 'LineWidth',2);
    dlmwrite('/Users/grendizer/Dropbox/Public/original.txt', [Traj Trajy]);
    dlmwrite('/Users/grendizer/Dropbox/Public/test.txt', [Test Testy]);
    dlmwrite(strcat(strcat('/Users/grendizer/Dropbox/Public/pcavariation', num2str(k)), '.txt'), MB', ' ');
end

%figure
%plot(dmpsA(1).C);

% write out into a file
%dlmwrite('/home/amor/Uni/papers/Humanoids2013/data/original.txt', [Traj Trajy]);
%dlmwrite('/home/amor/Uni/papers/Humanoids2013/data/test.txt', [Test Testy]);
%dlmwrite('/home/amor/Uni/papers/Humanoids2013/data/handwritingGen.txt', [MB(1,:)' MB(2,:)']);