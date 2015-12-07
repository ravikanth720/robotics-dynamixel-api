function channelsA = removeBvhPositions( skelA, channelsA )
%removeBvhPositions Sets all positions for bvh skeleton to 0
%   
    k=1;
    for i=1:size(skelA.tree,2)
        if(skelA.tree(i).posInd)
            posInds(k) = skelA.tree(i).posInd(1);
            k=k+1;

            posInds(k) = skelA.tree(i).posInd(2);
            k=k+1;

            posInds(k) = skelA.tree(i).posInd(3);
            k=k+1;
        end
    end

    for i=1:size(posInds,2)
       channelsA(:,posInds(1,i)) = channelsA(1,posInds(1,i)); 
    end

end

