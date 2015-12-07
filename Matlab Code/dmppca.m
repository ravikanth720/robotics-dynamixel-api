function [mapped, mapping] = dmppca(movModels, dims, visual)
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

if(visual == 1)
    % perform pca on w's
    [pc,score,latent,tsquare] = princomp(ws');

    cs = cumsum(latent)./sum(latent);
    bar(cs(1:4))
end

% do pca
[mapped, mapping] = compute_mapping(ws', 'PCA', dims);