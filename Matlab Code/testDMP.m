clear all;
close all;

% record a trajectory
[Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();
Time = linspace(0,2, size(Traj,1))';

% learn the dmp
[params, PHIX, ampX, wX, HX, CX, PHIY, ampY, wY, HY, CY] = learnDMP(Time, Traj, Trajy, Trajd, Trajdy, Trajdd, Trajddy)

figure
plot(Traj,Trajy)
% run the dmp
for i = 1:10
    X = runSingleDMP(Traj(1,1) + randn(1)*0.05, Traj(end,1), 0, 0, PHIX, ampX, wX, HX, CX, 1, params);
    Y = runSingleDMP(Trajy(1,1)+ randn(1)*0.05, Trajy(end,1),0, 0, PHIY, ampY, wY, HY, CY, 1, params);

    % plot the dmp
    hold on 
    plot(X,Y, 'g')
end