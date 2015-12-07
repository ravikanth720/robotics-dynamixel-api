function [condSigma, condMu] = gaussCondition(condY, invSigmaXX, SigmaYX, meanX, meanY)
muX = meanX';
muY = meanY';


% mean and covariance after conditioning
condSigma = 0;
condMu    = muY + SigmaYX*invSigmaXX*( condY' - muX ); 
end

