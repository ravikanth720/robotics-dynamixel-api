function[allG] = estimateGoals(params, dmps, passedPercentage, traj, trajd, trajdd, visual)

% calculate goal
allG  = [];
[sX sY] = size(traj);
for i = 1:sY
    goals = [];
    for k = 1:sX
        % get position, velocity and accel.
        y = traj(k,i);
        yd = trajd(k,i);
        ydd = trajdd(k,i);

        % compute phase
        newPercentage = floor(passedPercentage*(k/length(traj)))+1;
        phaseN = dmps(i).C(newPercentage);

        %Compute forceing function
        psi=exp(-1* dmps(i).H.*(phaseN- dmps(i).C).^2)';
        f=sum(dmps(i).w'*psi*phaseN)/(sum(psi));

        tg = y + ((ydd/(params.tau*params.tau) - (dmps(i).amp.*f))/params.alphay + (yd/params.tau))/params.betay;
        goals = [goals; tg];
        size(goals);
    end
    
    allG = [allG goals];
end

if visual == 1
    figure
    plot(goals);
end