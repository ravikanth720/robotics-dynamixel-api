function channels = appendMotion( channels, filename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[skelB, channelsB, frameLengthB] = bvhReadFile(filename);
channels = vertcat(channels,channelsB);



end
