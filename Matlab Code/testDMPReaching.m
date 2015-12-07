clear all;
close all;

%%Read data
f = ['/heni/data/punch/reaching1.txt';
     '/heni/data/punch/reaching2.txt';
     '/heni/data/punch/reaching3.txt';
     '/heni/data/punch/reaching4.txt';
     '/heni/data/punch/reaching5.txt';
     '/heni/data/punch/reaching6.txt';
     '/heni/data/punch/reaching7.txt';
     '/heni/data/punch/reaching8.txt';
     '/heni/data/punch/reaching9.txt'];
 
files = cellstr(f);

for i = 1:length(files)
    % load data
    data      = dlmread(files{i});
    
    % preprocess data
    data      = data(:, 4:end)';
    
    [params dmps] = learnMotorPrimitive(data);
    movModels(i)  = struct('data', data, 'dmps', dmps);
end

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
[mappedP, mappingP] = compute_mapping(ws', 'PCA', 3);

% generate new weights
newP  = randn(1,3) * 1.0e+12;
newWS = reconstruct_data(newP, mappingP);
imagesc(newWS)

% extract the individual wrighs
iw =[];
dmpsA = movModels(1).dmps;
for j= 1:length(movModels(1).dmps)
    dmpsA(j).w = newWS((j-1)*200+1:(j-1)*200+200);
    %iw = [iw; newWS((j-1)*200+1:(j-1)*200+200)];
end
iw

% use start position as goal state
goals = data(:,1)';

% execute the dmp
% execute motor primitive from estimated phase
MB = executeMotorPrimitive(params, movModels(2).dmps,  movModels(2).data(:,1)', ...
                                           movModels(2).data(:,end)', ... 
                                           zeros(1,6), ...
                                           zeros(1,6), ...
                                           1.0);

dlmwrite('/heni/result.txt', MB', ' ');

