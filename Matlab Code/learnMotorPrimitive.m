function [params, dmps] = learnMotorPrimitive(D)

% get size of dataset
[Dsx Dsy] = size(D);

% get accelerations and velocities 
% for each dimension
for i=1:Dsx
    
    % get the velocities and accelerations of each trajectory
    [x dx ddx] = getVelAccel(D(i,:));

    % trajectories for X component
    TX = struct('Traj',   x', ...
                'Trajd',  dx', ...
                'Trajdd', ddx');
        
    % put trajectories into an array
    TrajectoryArray(i) = TX;
end

% get time info
Time = linspace(0,1, size(TX.Traj,1))';

% learn the dmps
[params, dmps] = learnDMP(Time, TrajectoryArray);
