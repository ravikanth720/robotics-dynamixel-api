clear all;
close all;

% noise level
noise = 0.0

% record a trajectory
[Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();

% trajectories for X component
TX = struct('Traj',   Traj, ...
            'Trajd',  Trajd, ...
            'Trajdd', Trajdd);
        
% trajectories for Y component
TY = struct('Traj',   Trajy, ...
            'Trajd',  Trajdy, ...
            'Trajdd', Trajddy);

% put trajectories into an array
TrajectoryArray(1) = TX;
TrajectoryArray(2) = TY;

% get time info
Time = linspace(0,1, size(Traj,1))';

% learn the dmps
[params, dmps] = learnDMP(Time, TrajectoryArray);
timesteps = params.timesteps;    

figure
% run the dmp
for i = 3:3
    start = i;
    phase = dmps(1).C(start);
    
    % calculate velocity
    velX   = (Traj(start,1)  - Traj(start-1,1)) * 10;
    velY   = (Trajy(start,1) - Trajy(start-1,1)) * 10;

    % calculate acceleration
    accelX   = velX - (Traj(start-1,1) - Traj(start-2,1)) * 10;
    accelY   = velY - (Trajy(start-1,1)  - Trajy(start-2,1)) * 10;
    
    % get start position
    startsX = Traj(start,1); 
    startsY = Trajy(start,1);

    % reset the number of timesteps to execute
    params.timesteps = timesteps - start;
    
    % the dmps from different start positions
    X = runSingleDMP(Traj(start,1) +randn(1)*noise, Traj(end,1),  velX, accelX, dmps(1).PHI, dmps(1).amp, dmps(1).w, dmps(1).H, dmps(1).C, phase, params);
    Y = runSingleDMP(Trajy(start,1)+randn(1)*noise, Trajy(end,1), velY, accelY, dmps(2).PHI, dmps(2).amp, dmps(2).w, dmps(2).H, dmps(2).C, phase, params);
    
    % plot the dmp
    %figure
    hold on 
    %plot(Traj, Trajy)
    plot(startsX,startsY, '+');
    plot(X,Y, 'g');
end

% record a trajectory
if 1
    [Test Testy Testd Testdy Testdd Testddy] = recordTrajectory();

    TrainData = [Traj Trajy]; %Trajd Trajdy];
    TestData  = [Test Testy]; %Testd Testdy];
    
    % remove first entry
    %TrainData = TrainData - repmat(TrainData(1,:),size(TrainData,1),1);
    %TestData = TestData   - repmat(TestData(1,:),size(TestData,1),1);
    
    % matrix of frame distances
    cost = getDistanceMatrix(TrainData, TestData);

    % call dynamic time warop
    [dist, path, D, time] = dtw(cost, 1);
    
    % the frame in the animation where we are
    startFrame = floor(time*length(Traj));
    
    % the passed time in percent
    passedPercentage = floor(time*100);
    
    % the current phase
    phase = dmps(1).C(passedPercentage);
    
    % estimate the goals
    goalsX = estimateGoals(params, dmps(1), passedPercentage, Test, Testd, Testdd);
    goalsY = estimateGoals(params, dmps(2), passedPercentage, Testy, Testdy, Testddy);
    
    % calculate velocity
    velX = Testd(end);
    velY = Testdy(end); 
    
    % calculate acceleration
    accelX = Testdd(end);
    accelY = Testddy(end); 
                                         
    % reset the number of timesteps to execute
    params.timesteps = timesteps - startFrame;
    
    % complete drawing based on a dmp
    newX = runSingleDMP(Test(end,1),  goalsX(end), velX, accelX, dmps(1).PHI, dmps(1).amp, dmps(1).w, dmps(1).H, dmps(1).C, phase, params);
    newY = runSingleDMP(Testy(end,1), goalsY(end), velY, accelY, dmps(2).PHI, dmps(2).amp, dmps(2).w, dmps(2).H, dmps(2).C, phase, params);

    % plot the dmp
    figure 
    hold on
    plot(Test, Testy)
    plot(newX, newY, 'r')
end
