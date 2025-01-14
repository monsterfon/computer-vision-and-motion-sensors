% Read the data from the CSV file with original column names
opts = detectImportOptions('min2nmir.csv', 'VariableNamingRule', 'preserve');
DATA = readtable('tridst360.csv', opts);

% Display the variable names to confirm they are preserved
disp(DATA.Properties.VariableNames);

% Extract the relevant columns using original names
t = DATA{:, 'elapsed (s)'}; % Time in seconds
gyroData = DATA{:, {'x-axis (deg/s)', 'y-axis (deg/s)', 'z-axis (deg/s)'}}; % Gyroscope data

% Define the range for the gyroscope data
wz = gyroData(4000:6000, 3);
wy = gyroData(4000:6000, 2);
wx = gyroData(4000:6000, 1);

% Calculate maximum values
wz_min = max(wz);
wy_min = max(wy);
wx_min = max(wx);

disp(wz_min);

% Calculate mean values
wz_mean = mean(wz);
wy_mean = mean(wy);
wx_mean = mean(wx);

disp(wz_mean * 60 * 600);
disp(wy_mean * 60 * 600);
disp(wx_mean * 60 * 600);

% Extract a segment of the data for movement
move = gyroData(7048:8756, :);
plot(move);
hold on; % Hold the plot for further modifications

% Initialize rotation matrices
S = eye(3); % Identity matrix
S_or = eye(3); % Original identity matrix
S1 = eye(3); % Another identity matrix

% Adjust the move data
move(:, 1) = move(:, 1) - 0.004;
move(:, 2) = move(:, 2) - 0.004;
move(:, 3) = move(:, 3) - 0.004;

% Loop through each row of the movement data
for i = 1:size(move, 1)
    v = sqrt(move(i, 1)^2 + move(i, 2)^2 + move(i, 3)^2);
    
    if v == 0
        continue; % Skip if the vector is zero to avoid division by zero
    end
    
    phi = 1/60 * v; % Calculate the rotation angle
    unit_wx = move(i, 1) / v; 
    unit_wy = move(i, 2) / v;
    unit_wz = move(i, 3) / v;

    unit_vector = [unit_wx, unit_wy, unit_wz];

    % Check for NaN values
    if any(isnan(unit_vector)) 
        unit_vector = [0, 0, 0];
    end
    
    % Create rotation quaternion and matrix
    R1 = fnRotacijskiKvaternion(phi, unit_vector);
    R = fnRotacijskaMatrika(phi, unit_vector);
    
    % Rotate the matrices
    S1 = fnRotirajSKvaternionom(S, R1);
    S = fnRotirajZMatriko(S, R);
end

disp(S)

% Calculate the difference in rotation
diff = 180/pi * acos((S(1, 1) + S(2, 2) + S(3, 3) - 1) / 2);
diff2 = 180/pi * acos((S_or(1, 1) + S_or(2, 2) + S_or(3, 3) - 1) / 2);

disp(diff)
disp(diff2)

% Uncomment the following lines to test additional rotations
% v = [1, 1, 1] / sqrt(3);
% S = eye(3);
% phi = pi/2;
% R = fnRotacijskaMatrika(phi, v);
% q = fnRotacijskiKvaternion(phi, v);
% fnRotirajZMatriko(S, R);
% fnRotirajSKvaternionom(S, q);
% 
% phi = 2*pi/3;
% R = fnRotacijskaMatrika(phi, v);
% q = fnRotacijskiKvaternion(phi, v);
% fnRotirajZMatriko(S, R);
% fnRotirajSKvaternionom(S, q);
% 
% phi = -2*pi/3;
% R = fnRotacijskaMatrika(phi, v);
% q = fnRotacijskiKvaternion(phi, v);
% fnRotiraj
