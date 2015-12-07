clear all;
close all;

goalNoise = 0.005;

% record a trajectory
[Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();

% learn motor primtive
[paramsA dmpsA] = learnMotorPrimitive([Traj Trajy]');

figure
hold on
% execute the dmp
for i = 1:10
    MA = executeMotorPrimitive(paramsA, dmpsA, [Traj(1) Trajy(1)], [Traj(end)+randn()*goalNoise Trajy(end)+randn()*goalNoise], [0 0], [0 0], 1.0);
    plot(MA(1,:), MA(2,:), 'b', 'LineWidth',1);
end
