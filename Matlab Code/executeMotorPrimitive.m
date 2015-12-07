function [O] = executeMotorPrimitive(params, dmps, startPos, endPos, vel, accel, phase)

% output
O = [];

% run the dmp
for i = 1:length(dmps)
    TX    = dmps(i).OrigTraj;
    
    % sanity check for endPosition
    if endPos == 0
        endP = TX(end,1);
    else
        endP = endPos(1,i);
    end
    %dmps(i).amp 
    
    % the dmps from different start positions
    X = runSingleDMP(startPos(1,i), endP, vel(1,i), accel(1,i), dmps(i).PHI, dmps(i).amp, dmps(i).w, dmps(i).H, dmps(i).C, phase, params);

    
    % concatenate current output
    O = [O; X];
    
    
end
