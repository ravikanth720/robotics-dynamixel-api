

filename = 'positions.txt';
delimiterIn = ' ';
headerlinesIn = 0;
A = importdata(filename,delimiterIn,headerlinesIn);
%A
%A=B(:,1:3:end);
%

%disp(A);
%for i = 1:4
%    vector = A(:, i);
%    disp(vector);
%end

% learn motor primtive
%[paramsA dmpsA] = learnMotorPrimitive([Traj Trajy]');
%[paramsA dmpsA] = learnMotorPrimitive([A(:, 1) A(:, 2) A(:, 3) A(:, 4)]');

[paramsA dmpsA] = learnMotorPrimitive(A');

goalNoise = 2.05;

zeroVector = zeros(1, 18);
noiseVector = randn(1, 18) * goalNoise;

MA = executeMotorPrimitive(paramsA, dmpsA, A(1,:), A(end,:)+noiseVector, zeroVector, zeroVector, 1.0);
MA'

%fileID = fopen('dmp_positions.txt','w');
dlmwrite('dmp_positions.txt',MA','delimiter' , ' ' );
%fclose(fileID)


