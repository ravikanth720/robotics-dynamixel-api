function [x y dx dy ddx ddy] = recordTrajectory()
figure; 
h = imfreehand;data=get(h); 
xydata=get(data.Children(4)); 
x=xydata.XData; 
y=xydata.YData; 
figure; plot(x,y,'.');

%calculate velocities
dx = x(2:end) - x(1:end-1);
dy = y(2:end) - y(1:end-1);

%calculate accelerations
ddx = (dx(2:end) - dx(1:end-1))';
ddy = (dy(2:end) - dy(1:end-1))';

% cut down parts where we
% dont have acceleration
dx = dx(2:end)';
dy = dy(2:end)';
x  = x(3:end)';
y  = y(3:end)';

figure;
hold on
plot(x)
plot(dx) 
plot(ddx)