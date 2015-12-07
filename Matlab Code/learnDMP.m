function [params, dmps] = learnDMP(Time, TrajectoryArray)

% DONT TOUCH THESE PARAMETERS!
%Set dynamic system parameters
nrlmodel = 200;
alphay   = 200;              %Dyanmics constant
alphax   = alphay/3;        %Canonical system constant
betay    = alphay/4;        %Dyanmics constant
dt       = mean(diff(Time)); 
tau      = 0.5/2.0;         %time
timesteps = size(Time,1);

% concatenate all dimensions
td = []; 
for i=1:length(TrajectoryArray)
    td = [td TrajectoryArray(i).Traj];
end

% put parameters into a structure
params = struct('tau',tau, ...
                'nrlmodel', nrlmodel, ... 
                'alphax', alphax, ...
                'alphay', alphay, ...
                'betay', betay, ...
                'dt', dt, ...
                'timesteps', timesteps, ...
                'trainingdata', td);

for i = 1:length(TrajectoryArray)
    % get trajectory of ith dimension
    tmp = TrajectoryArray(i);
    
    % learn dmp fo trajectory
    [PHIX, ampX, wX, HX, CX] = singleDMP(Time, tmp.Traj, tmp.Trajd, tmp.Trajdd, params);
    
    %put dmp into a structure
    tmpDMP = struct('PHI', PHIX, ...
                  'amp', ampX, ... 
                  'w',   wX, ...
                  'H',   HX, ...
                  'C',   CX, ...
                  'OrigTraj', tmp.Traj);

    dmps(i) = tmpDMP;
end
