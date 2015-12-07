function [invSigmaXX, SigmaYX, condSigma, condMu] = extractIndividualCovariances(C, condY, meanX, meanY)

M = size(condY,2);

muX = meanX';
muY = meanY';

bigCovarianceMatrix = C;

SigmaXX = bigCovarianceMatrix(1:M,1:M);
SigmaXY = bigCovarianceMatrix(1:M,M+1:end);
SigmaYX = bigCovarianceMatrix(M+1:end,1:M);
SigmaYY = bigCovarianceMatrix(M+1:end,M+1:end);

invSigmaXX = pinv(SigmaXX);

% mean and covariance after conditioning
condSigma = 0;
condMu    = muY + SigmaYX*invSigmaXX*( condY' - muX ); 
end

