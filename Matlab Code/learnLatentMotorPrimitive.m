function [params, dmps] = learnLatentMotorPrimitive(D, mapping)

% project to low dimensional space
mappedD = out_of_sample(D,mapping);

% learn the dmps in latent space
[params, dmps] = learnMotorPrimitive(mappedD');
