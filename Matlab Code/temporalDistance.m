function d = temporalDistance(v1, v2)

% squared distance
%d = sqrt(sum((v1 - v2).^2))
d =  sum(abs(v1 - v2));
%d = (sum(abs(v1 - v2)))^2;