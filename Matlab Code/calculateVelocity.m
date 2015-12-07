function vel = calculateVelocity(A)
% calculate the changes
[sizeX sizeY]= size(A);
vel = zeros(sizeX-1,sizeY);

for i=2:sizeX
    vel(i-1,:) = A(i,:) - A(i-1,:);
end