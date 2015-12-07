function [dtw, path, D] = dtw2(cost, visual) 

if nargin < 2
  visual = 0;
end

% code dtw
[sX, sY] = size(cost);

% costs
D = zeros(sX, sY);
D(1,:) = inf;
D(:,2) = inf;
D(2,2) = 0;
D(1,1) = 0;
%D(2:(sX+1), 2:(sY+1)) = cost;

% traceback
phi = zeros(sX+1,sY+1);

for i = 3:sX; 
  for j = 3:sY;
      [C,index] =  min([D(i-1, j-1), D(i-2, j-1), D(i-1, j-2)]); 
      D(i,j) = cost(i,j) + C; 
      phi(i,j) = index;
  end
end

figure 
imagesc(phi);

bla 

% Traceback from top left
i = sX+1;
j = sY+1;
p = i;
q = j;

while i > 2 & j > 2
  tb = phi(i,j);
  if i == 2
        j = j - 1;
  elseif j == 2 
        i = i - 1;
  end
  
  if (tb == 1)
    i = i-1;
    j = j-1;
  elseif (tb == 2)
    i = i-2;
    j = j-1;
  elseif (tb == 3)
    j = j-2;
    i = i-1;
  else    
    error;
  end 
  p = [i,p];
  q = [j,q];
end

% Strip off the edges of the D matrix before returning
D = D(2:(sX+1),2:(sY+1));

% map down p and q
p = p-1;
q = q-1;
path = [p; q]';

if visual == 1
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

path = fliplr(path')';

dtw  = D(sX,sY);