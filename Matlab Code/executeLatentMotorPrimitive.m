function [O] = executeLatentMotorPrimitive(params, dmps, startPos, endPos, vel, accel, phase, mapping)

% execute the dmps
r = executeMotorPrimitive(params, dmps, startPos, endPos, vel, accel, phase)

% map back into high-dimensional space
O = reconstruct_data(r', mapping);
