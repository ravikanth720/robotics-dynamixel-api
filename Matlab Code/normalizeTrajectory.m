function [normTraj] = normalizeTrajectory(traj)

normTraj = [];
for i = 1:size(traj,2)
    normTraj = [normTraj (traj(:,i)/norm(traj(:,i)))];
end
