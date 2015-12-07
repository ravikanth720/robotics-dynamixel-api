function trans = calculateTransitionMatrix(idx, states, prob)

% count the number of state transitions
sizeX = size(idx,1);
trans = zeros(states, states);

for i = 1:sizeX-1
    trans(idx(i),idx(i+1)) = trans(idx(i),idx(i+1)) + 1;
end

if prob == 1
    for i = 1:states
        sumS  = sum(trans(i,:));
        for j = 1:states
            trans(i,j) = trans(i,j)/ sumS;
        end
    end
end
        
