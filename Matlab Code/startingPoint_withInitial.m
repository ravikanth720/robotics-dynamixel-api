

filename = 'positions.txt';
delimiterIn = ' ';
headerlinesIn = 0;
A = importdata(filename,delimiterIn,headerlinesIn);

filename_newstart = 'initial_position.txt';
B = importdata(filename_newstart,delimiterIn,headerlinesIn);


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

%MA = executeMotorPrimitive(paramsA, dmpsA, A(1,:), A(end,:)+noiseVector, zeroVector, zeroVector, 1.0);
MA = executeMotorPrimitive(paramsA, dmpsA, B(1,:), A(end,:)+noiseVector, zeroVector, zeroVector, 1.0);

MA'

dlmwrite('dmp_positions.txt',MA','delimiter' , ' ' );





