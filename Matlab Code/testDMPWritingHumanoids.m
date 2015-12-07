clear all;
close all;

% record a trajectory
[Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();

% learn motor primtive
[paramsA dmpsA] = learnMotorPrimitive([Traj Trajy]');

figure
hold on
% execute the dmp
for i = 1:1
    MA = executeMotorPrimitive(paramsA, dmpsA, [Traj(1) Trajy(1)], [Traj(end) Trajy(end)], [0 0], [0 0], 1.0);
    plot(MA(1,:), MA(2,:), 'g');
end

% record a new partial-trajectory
[Test Testy Testd Testdy Testdd Testddy] = recordTrajectory();

% normalize trajectory
normTraj = normalizeTrajectory([Trajd Trajdy]);
normTest = normalizeTrajectory([Testd Testdy]);

% estimate the phase
[phase passedPercentage time path] = estimatePhaseDerivative(normTraj, normTest, paramsA, dmpsA, [Test Testy]);

% extract segment
[nlength segment] = extractSegmentFromTrajectory(time, [Traj Trajy]);

%figure 
%hold on
%plot(segment(:,1), segment(:,2), 'r');
%plot(Test, Testy, 'b');

%figure
% extract scales
scales = getScale(segment, [Test Testy]);
dmpsA = scaleDMPs(scales, dmpsA); 

% estimate the final goal
goals = estimateGoals(paramsA, dmpsA, passedPercentage, [Test Testy], [Testd Testdy], [Testdd Testddy], 1);

% the frame in the animation where we are
startFrame = floor(time*length(Traj));

% reset the number of timesteps to execute
paramsA.timesteps = paramsA.timesteps - startFrame;

% vel + accelerations
vel   = [Testd(end) Testdy(end)];
accel = [Testdd(end) Testddy(end)];

% plot the executed path
figure
plot(MA(1,:), MA(2,:), 'b', 'LineWidth',2);

figure
for i=1:1
    % execute motor primitive from estimated phase
    MB = executeMotorPrimitive(paramsA, dmpsA, [Test(end) Testy(end)], ...
                                           goals(end, :), ... 
                                           vel, ...
                                           accel, ...
                                           phase);

    hold on
    plot(Traj, Trajy, 'b', 'LineWidth',1);
    plot(Test, Testy, 'g', 'LineWidth',2);
    plot(MB(1,:), MB(2,:), 'r', 'LineWidth',2);
end 
figure
plot(dmpsA(1).C);

% write out into a file
dlmwrite('/home/amor/Uni/papers/Humanoids2013/data/original.txt', [Traj Trajy]);
dlmwrite('/home/amor/Uni/papers/Humanoids2013/data/test.txt', [Test Testy]);
dlmwrite('/home/amor/Uni/papers/Humanoids2013/data/handwritingGen.txt', [MB(1,:)' MB(2,:)']);