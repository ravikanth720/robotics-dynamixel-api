function [scales] = getScale(A,B)
%Ratio of the two part trajectories

scales = [];
for i = 1:size(A,2)
    maxa = max(A(:, i));
    mina = min(A(:, i));

    maxb = max(B(:, i));
    minb = min(B(:, i));

    diffa = maxa-mina;
    diffb = maxb-minb;
    ratio=diffb/diffa;
    scales = [scales; ratio];
end