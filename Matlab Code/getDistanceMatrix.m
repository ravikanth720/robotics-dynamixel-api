function dist = getDistanceMatrix(A, B)

% size of the channels
sizeA = size(A, 1);
sizeB = size(B, 1);

% matrix of frame distances
dist = zeros(sizeA, sizeB);

for i = 1:sizeA
    for j = 1:sizeB
        % calculate the distance for each frame
        v1 = A(i,:);
        v2 = B(j,:);
        dist(i,j) = temporalDistance(v1,v2);
    
    end
end