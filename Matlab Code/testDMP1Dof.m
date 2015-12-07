clear all;
close all;

figure
for i = 1:3
    % record a trajectory
    [Traj Trajy Trajd Trajdy Trajdd Trajddy] = recordTrajectory();

    % learn motor primtive
    [params dmps] = learnMotorPrimitive([Trajy]');
  
    movModels(i)  = struct('data', [Trajy]', 'dmps', dmps);
end

% do pca
[mappedP, mappingP] = dmppca(movModels, 2 , 0);

figure
for k = 1:30
    % generate new weights
    newP  = -0.5 * abs(randn(1,2)) * 1.0e+12 - (0.25*1.0e+12);
    newWS = reconstruct_data(newP, mappingP);
    %imagesc(newWS)

    % extract the individual wrighs
    iw =[];
    dmpsA = movModels(1).dmps;
    for j= 1:length(movModels(1).dmps)
        dmpsA(j).w = newWS((j-1)*200+1:(j-1)*200+200);
        %iw = [iw; newWS((j-1)*200+1:(j-1)*200+200)];
    end

    %% END

    %%%%%% compute pca over all final positions
    %[goalMapped, goalMapping] = compute_mapping(finalP', 'PCA', 3);
    %newLatentGoal             = [0, 0, (0.3*k-1.5)]; 
    %newGoal                   = reconstruct_data(newLatentGoal, goalMapping);
    %%%%%%
    
    % execute the dmp
    for i = 1:length(movModels(1).dmps)
        movModels(2).dmps(i).w = dmpsA(i).w';
    end
    
    hold on
    % execute the dmp
    
    MA = executeMotorPrimitive(params, movModels(2).dmps, [Trajy(1)], [Trajy(end)+randn(1)*0.1], [0], [0], 1.0);
    plot(MA(1,:), 'g');
end
