function [dtw, path, D, time] = dtw(cost, visual) 

if nargin < 2
  visual = 0
end

% code dtw
[sX, sY] = size(cost);

%window size
% HACK!!!
w = 20;

D   = zeros(sX, sY);
D(1:sX,1:sY) = inf;
D(1,1) = 0;

% the directions to go
phi = zeros(sX, sY);
        
for i = 2:sX
    minV = max(2,i-w);
    maxV = min(sY, i+w);
    
    for j = minV:maxV
        [C,index] =  min([D(i-1, j), D(i, j-1), D(i-1, j-1)]); 
        D(i,j) = cost(i,j) + C; 
        phi(i,j) = index;
    end
end

%calculate the entry with minimum
%distance in the final column
[C,minIndex] = min(D(:, sY));
i = minIndex;
j = sY;
path = [i, j];

% calculate path
while i > 1 & j > 1
    if i == 1
        j = j - 1;
    elseif j == 1 
        i = i - 1;
    else
        index = phi(i,j);
        
        % step
        if index == 1
            i = i-1;
        elseif index == 2
            j = j - 1;
        else
            i = i - 1;
            j = j - 1;
        end
    end
lastIndex = index;
path = [path; i, j];     
end
%path = [path; 1, 1];


if visual == 1
    figure 
    imagesc(cost);
    figure 
    imagesc(phi);
    hold on
    plot(path(:,2), path(:,1), 'w')
    figure
    imagesc(D);
    hold on
    plot(path(:,2), path(:,1), 'w')
    D
end

% return minimum distance
dtw  = D(sX,sY);

% return time fraction
time = minIndex / sX;