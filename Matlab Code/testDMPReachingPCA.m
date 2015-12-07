clear all;
close all;

dims = 3;

%%Read data
f = ['/heni/data/reaching/reaching1.txt';
     '/heni/data/reaching/reaching2.txt';
     '/heni/data/reaching/reaching4.txt';
     '/heni/data/reaching/reaching6.txt';
     '/heni/data/reaching/reaching8.txt';];
 
files = cellstr(f);

allData = [];
finalP  = [];
for i = 1:length(files)
    % load data
    data      = dlmread(files{i});
    
    % preprocess data
    allData      = [allData; data];
end

% do pca
[mappedP, mappingP] = compute_mapping(allData, 'PCA', dims);

% print first two dimensions of PCA
plot(mappedP(:,1), mappedP(:,2));

% print out the pca coordinates for each file
for i = 1:length(files)
    % load data
    data      = dlmread(files{i});
    
    % preprocess data
    currData  = out_of_sample(allData, mappingP);
    
    % save to file
    fname = sprintf('preach%d.txt', i);
    dlmwrite(strcat('/heni/data/projReaching/', fname), currData, ' ');
end

%%%
%% Now load the low dimensional points
f      = '/heni/data/reaching/reaching2.txt';
ndata   = dlmread(f);

% learn motor primtive
[params dmps] = learnLatentMotorPrimitive(ndata, mappingP);

figure
hold on
% execute the dmp
for i = 1:1
    MA = executeLatentMotorPrimitive(params, dmps, mappedP(1,:), mappedP(randi(500),:), [0 0 0], [0 0 0], 1.0, mappingP);
    plot(MA(1,:), MA(2,:), 'g');
end

dlmwrite('/heni/resultPCA.txt', MA, ' ');
