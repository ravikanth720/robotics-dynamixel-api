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

% estimate the phase
[phase passedPercentage time path] = estimatePhase(paramsA, dmpsA, [Test Testy]);

% estimate the final goal
goalsX = estimateGoals(paramsA, dmpsA(1), passedPercentage, Test, Testd, Testdd, 1);
goalsY = estimateGoals(paramsA, dmpsA(2), passedPercentage, Testy, Testdy, Testddy, 1);

% the frame in the animation where we are
startFrame = floor(time*length(Traj));

% reset the number of timesteps to execute
paramsA.timesteps = paramsA.timesteps - startFrame;

% vel + accelerations
vel   = [Testd(end) Testdy(end)];
accel = [Testdd(end) Testddy(end)];
    
% execute motor primitive from estimated phase
MB = executeMotorPrimitive(paramsA, dmpsA, [Test(end) Testy(end)], ...
                                           [goalsX(1) goalsY(1)], ... 
                                           vel, ...
                                           accel, ...
                                           phase);

% plot the executed path
figure
plot(MA(1,:), MA(2,:), 'b', 'LineWidth',2);

figure
hold on
plot(Test, Testy, 'g', 'LineWidth',2);
plot(MB(1,:), MB(2,:), 'r', 'LineWidth',2);

figure
plot(dmpsA(1).C);