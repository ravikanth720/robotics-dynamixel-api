function [dmps] = sampleDmpFromPca(movModels, mapping, mapped)
% generate new weights
newP  = 0.4 * randn(1,size(mapped, 2)) .* max(mapped);
newWS = reconstruct_data(newP, mapping);
%imagesc(newWS)

% extract the individual wrighs
iw =[];
dmps = movModels(1).dmps;
sx = length(movModels(1).dmps(1).w);
for j= 1:length(movModels(1).dmps)
    dmps(j).w = newWS((j-1)*sx+1:(j-1)*sx+sx)';
    %iw = [iw; newWS((j-1)*200+1:(j-1)*200+200)];
end
