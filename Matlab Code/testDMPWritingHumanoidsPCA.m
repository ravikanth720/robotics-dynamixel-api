clear all;
close all;

figure
for i = 1:5
    % record a trajectory
    [Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();

    % learn motor primtive
    [params dmps] = learnMotorPrimitive([Traj Trajy]');
  
    movModels(i)  = struct('data', [Traj Trajy]', 'dmps', dmps);
end

% do pca
[mappedP, mappingP] = dmppca(movModels, 3 , 0);

figure
hold on    
for k = 1:4
    sampledDMPs = sampleDmpFromPca(movModels, mappingP, mappedP);
    
    % execute the dmp
    MA = executeMotorPrimitive(params, movModels(2).dmps, [Traj(1) Trajy(1)], [Traj(end)+randn(1)*0.0 Trajy(end)+randn(1)*0.00], [0 0], [0 0], 1.0);
    plot(MA(1,:), MA(2,:), 'g');
end
