function [dmps] = scaleDMPs(scales, dmps)

for i = 1:length(dmps)
    dmps(i).amp = dmps(i).amp *scales(i);
end
end