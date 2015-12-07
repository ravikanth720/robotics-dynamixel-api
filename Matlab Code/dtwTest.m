X = [9,3,1,5,1,2,0,1,0,2,2,8,1,7,0,6,4,4,5];
Y = [1,2,9,3,1,5,1,2,0,1];

figure
plot([1:size(X,2)], X)
hold on
plot([1:size(Y,2)], Y, 'g')

% compute distance matrix
for i=1:size(X,2)
    for j =1:size(Y,2)
        cost(i,j) = abs(X(1, i) - Y(1, j));
    end
end

% call dynamic time warop
[dist, path, D] = dtw(cost);

% warped Y
wy = Y(fliplr(path(:,2)'));
wx = X(fliplr(path(:,1)'));
figure
plot([1:size(wx,2)], wx)
hold on
plot([1:size(wy,2)], wy, 'red','LineWidth',2)