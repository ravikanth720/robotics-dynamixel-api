function [nlength segment] = extractSegmentFromTrajectory(time, traj)
%Partial Trajectory to be analyzed
% Added variables for goal change

%length of the trajectory to be analyzed
nlength = time*size(traj,1) ;

%new data of trajy to be analyzed
segment = traj(1:ceil(nlength), :); 
end
