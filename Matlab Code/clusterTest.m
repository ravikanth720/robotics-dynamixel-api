A = [30; 50; 95; 90; 93; 88; 91; 100];

% cluster using kmeans
opts = statset('Display','final');
[idx,prototypes] = kmeans(A,3,'Distance','sqEuclidean','Replicates',100,'Options',opts);

idx