function [x dx ddx] = getVelAccel(I)

%calculate velocities
dx = I(2:end) - I(1:end-1);

%calculate accelerations
ddx = (dx(2:end) - dx(1:end-1));

% cut down parts where we
% dont have acceleration
dx = dx(2:end);
x  = I(3:end);
