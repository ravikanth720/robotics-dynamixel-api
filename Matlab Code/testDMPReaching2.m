clear all;
close all;

%%Read data
f = ['/heni/data/reaching/reaching1.txt';
     '/heni/data/reaching/reaching2.txt';
     '/heni/data/reaching/reaching3.txt';
     '/heni/data/reaching/reaching5.txt';
     '/heni/data/reaching/reaching4.txt';];
 
files = cellstr(f);

finalP = [];
for i = 1:length(files)
    % load data
    data      = dlmread(files{i});
    
    % preprocess data
    data      = data';
    
    fpos = data(:,length(data));
    [params dmps] = learnMotorPrimitive(data);
    finalP = [finalP fpos];
    movModels(i)  = struct('data', data, 'dmps', dmps);
end


%% DO PCA stuff
%% Extract the w's and create concatenated ws for all DOF
ws = [];
for i = 1:length(movModels)
    w = [];
    for j= 1:length(movModels(1).dmps)
        w = [w; movModels(i).dmps(j).w];
    end
    ws = [ws w];
end

% perform pca on w's
[pc,score,latent,tsquare] = princomp(ws');

cs = cumsum(latent)./sum(latent);
bar(cs(1:4))

% do pca
[mappedP, mappingP] = compute_mapping(ws', 'PCA', 4);

for k = 1:10
    % generate new weights
    newP  = 0.3 * randn(1,4) * 1.0e+12;
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
    [goalMapped, goalMapping] = compute_mapping(finalP', 'PCA', 3);
    newLatentGoal             = [(0.3*k-1.5), 0, 0]; 
    newGoal                   = reconstruct_data(newLatentGoal, goalMapping);
    %%%%%%
    
    % execute the dmp
    for i = 1:length(movModels(1).dmps)
        movModels(2).dmps(i).w = dmpsA(i).w';
    end

    % execute motor primitive from estimated phase
    %newGoal, ... movModels(2).data(:,end)'
    MB = executeMotorPrimitive(params, movModels(2).dmps,  movModels(2).data(:,1)', ...
                                           newGoal, ...
                                           zeros(1,9), ...
                                           zeros(1,9), ...
                                           1.0);

    dlmwrite(strcat(strcat('/heni/result', num2str(k)), '.txt'), MB', ' ');
end
