function tempData = temporalEmbedding(X, lag)
tempData = [];

[sX sY]  = size(X);
for tstep = 1+lag:sX-lag
    test = [];
    for i = 1:lag
        test = [test X(tstep-i,:)];
    end
    tempData = [tempData; test];
end
