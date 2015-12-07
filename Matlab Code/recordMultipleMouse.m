clear all;
close all;

numPics = 2; 
% record mutiple trajectories            
for i=1:numPics
    % record a trajectory
    [x y xd yd xdd ydd] = recordTrajectory();
    D(i) = struct('x',    x,  ...
                  'y',    y,  ... 
                  'xd',  xd,  ...
                  'yd',  yd,  ...
                  'xdd', xdd, ...
                  'ydd', ydd, ...
                  'dtwx', [],  ...
                  'dtwy', []);
end    

% plot the x coordinates
figure
for i=1:numPics
    hold on
    D(i).x(:) = D(i).x(:) - D(i).x(1);
    plot(D(i).x);
end


%Time = linspace(0,2, size(Traj,1))';

% learn the dmp
%[~, ~, ~, wX1, ~, ~, ~, ~, wY1, ~, ~] = learnDMP(Time, Traj, Trajy, Trajd, Trajdy, Trajdd, Trajddy)

%figure
%A = D(1).x;
%for i=1:numPics
%    B = D(i).x;

    % matrix of frame distances
%    cost = getDistanceMatrix(A, B);
    
    % call dynamic time warop
%    [dist, path, E, time] = dtw(cost, 1);

    % warped Y
%    wx = A(fliplr(path(:,1)'), :);
%    wy = B(fliplr(path(:,2)'), :);
    
%    D(i).dtwx = wx;
%    D(i).dtwy = wy;
%end

%figure
%for i=1:numPics
%    hold on
%    plot(D(i).dtwx);
%    plot(D(i).dtwy);
%end

%figure
%plot(Traj,Trajy)
% run the dmp
%for i = 1:10
%    X = runSingleDMP(Traj(1,1) + randn(1)*0.05, Traj(end,1), 0, 0, PHIX, ampX, wX, HX, CX, 1, params);
%    Y = runSingleDMP(Trajy(1,1)+ randn(1)*0.05, Trajy(end,1),0, 0, PHIY, ampY, wY, HY, CY, 1, params);

    % plot the dmp
%    hold on 
%    plot(X,Y, 'g')
%end