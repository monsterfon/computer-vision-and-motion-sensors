clear all; close all; clc;
addpath('libVaje');

% Step 2: Import signals into Matlab
DATA = readtable('sensordata_2.csv');
t = DATA.SamplingTime;
acc = [-DATA.AccelerationX -DATA.AccelerationY -DATA.AccelerationZ];
om = [-DATA.GyroX -DATA.GyroY -DATA.GyroZ];

% Adjust time to start from zero
t = t - t(1);
fs = 100;  % Sampling frequency
Ts = 1/fs;  % Sampling period
deltaT = diff(t);

% Define stationary periods
st_stanje_zac1 = 50;
st_stanje_kon1 = 680;
st_stanje_zac2 = 2520;
st_stanje_kon2 = 3010;

% Step 3: Calculate the average orientation of the gravity vector during initial rest
g0_initial = mean(acc(st_stanje_zac1:st_stanje_kon1,:))';
g0_final = mean(acc(st_stanje_zac2:st_stanje_kon2,:))';

disp('Povprečna gravitacija v stacionarnem stanju 1:');
disp(g0_initial)
disp('Povprečna gravitacija v stacionarnem stanju 2: (90st)');
disp(g0_final)

% Initialize rotation matrix and reference acceleration
R = eye(3);
a_ref = zeros(size(acc));

% Calculate reference acceleration during initial rest
for i = st_stanje_zac1:st_stanje_kon1
    a_ref(i,:) = (acc(i,:)' - g0_initial)';
end

% Initialize rotation matrix for subsequent motion
% Step 3: Calculate rotation matrix and transform acceleration for the rest of the motion
for i = (st_stanje_kon1+1):length(om)
    om_norm = sqrt(sum(om(i,:).^2));
    if om_norm > 1e-10
        v = om(i,:)./om_norm;  % Calculate the unit vector of the angular velocity
        phi = om_norm * Ts;  % Calculate the rotation angle
        R = R*fnRotacijskaMatrika(phi, v);  % Update the rotation matrix
    end
    % rotacijsko matriko uporabite za preslikavo merjenega pospeška v začetni, referenčni koordinatni sistem;
    g_current = R * g0_initial;  % Transform the gravity vector to the current reference frame
    a_ref(i,:) = (acc(i,:)' - g_current)';  % Transform the acceleration to the initial reference frame and subtract g0
end

% Calculate final gravity vector
g_final = R * g0_initial;

% Initialize velocity and displacement
v = zeros(size(acc));
s = zeros(size(acc));

% Calculate time differences
deltaT = t(2:end) - t(1:end-1);

% Step 3: Numerically integrate to calculate velocity and displacement
for i = 2:length(acc)
    v(i,:) = v(i-1,:) + a_ref(i-1,:) * deltaT(i-1) * 9.81;
    s(i,:) = s(i-1,:) + v(i-1,:) * deltaT(i-1) + 0.5 * a_ref(i-1,:) * deltaT(i-1)^2 * 9.81;
end

% Calculate total distance traveled
total_distance = sum(sqrt(sum(diff(s).^2, 2)));
fprintf('Total distance traveled: %.4f m\n', total_distance);

% Initialize new velocity and displacement for original acceleration data
v_raw = zeros(size(acc));
s_raw = zeros(size(acc));

% Numerically integrate to calculate velocity and displacement using raw acceleration data
for i = 2:length(acc)
    v_raw(i,:) = v_raw(i-1,:) + acc(i-1,:) * deltaT(i-1) * 9.81;
    s_raw(i,:) = s_raw(i-1,:) + v_raw(i-1,:) * deltaT(i-1) + 0.5 * acc(i-1,:) * deltaT(i-1)^2 * 9.81;
end

% Step 4: Compensate for sensor errors
gyro_bias1 = mean(om(st_stanje_zac1:st_stanje_kon1,:));
gyro_bias2 = mean(om(st_stanje_zac2:st_stanje_kon2,:));
gyro_bias = (gyro_bias1 + gyro_bias2) / 2;

om_corrected = om - gyro_bias;

R = eye(3);
a_ref = zeros(size(acc));

for i = st_stanje_zac1:st_stanje_kon1
    a_ref(i,:) = (acc(i,:)' - g0_initial)';
end

S = [1 0 0; 0 1 0; 0 0 1];

for i = (st_stanje_kon1+1):length(om_corrected)
    om_norm = sqrt(sum(om_corrected(i,:).^2));
    
    if om_norm > 1e-10  
        v = om_corrected(i,:)./om_norm;
        phi = om_norm * Ts;  
        R = R*fnRotacijskaMatrika(phi, v);
    end
    g_current = R * g0_initial;
    a_ref(i,:) = (acc(i,:)' - g_current)';
end

S=fnRotirajZMatriko(S,R);

v = zeros(size(acc));
s = zeros(size(acc));
deltaT = t(2:end) - t(1:end-1);

for i = 2:length(acc) 
    v(i,:) = v(i-1,:) + a_ref(i-1,:) * deltaT(i-1) *9.81; 
    s(i,:) = s(i-1,:) + v(i-1,:) * deltaT(i-1) + 0.5 * a_ref(i-1,:) * deltaT(i-1)^2*9.81;
end

g_final = R * g0_initial;

n = 1:length(v);
st_polinoma = 1;
v_drift = zeros(size(v));
st1 = st_stanje_kon1;
st2 = st_stanje_zac2;
v_drift = zeros(size(v));

% Fix drift for a_ref instead of v
for i = 1:3
    p_drift = polyfit([st1 st2], [a_ref(st1,i); a_ref(st2,i)], st_polinoma);  
    a_ref_drift = polyval(p_drift, st1:length(a_ref));
    a_ref(st1:end,i) = a_ref(st1:end,i) - a_ref_drift';
end

% Set acceleration to zero after 25 seconds
zero_index = find(t >= 25, 1);
if ~isempty(zero_index)
    a_ref(zero_index:end, :) = 0;
end

v_comp = zeros(size(v));
s_comp = zeros(size(s));

for i = 2:length(acc)
    v_comp(i,:) = v_comp(i-1,:) + a_ref(i-1,:) * deltaT(i-1) * 9.81;
    s_comp(i,:) = s_comp(i-1,:) + v_comp(i-1,:) * deltaT(i-1) + ...
                  0.5*a_ref(i-1,:)*deltaT(i-1)^2*9.81;
end

total_distance = sum(sqrt(sum(diff(s_comp).^2, 2)));
fprintf('Total distance traveled: %.4f m\n', total_distance);

% Step 4: Plot compensated results
figure;
subplot(2,1,1);
plot(t, v_comp);
title('Compensated Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('X', 'Y', 'Z');

subplot(2,1,2);
plot(t, s_comp);
title('Compensated Position');
xlabel('Time (s)');
ylabel('Position (m)');
legend('X', 'Y', 'Z');

% Function to calculate rotation matrix using Rodrigues' rotation formula
function R = fnRotacijskaMatrika(phi, v)
    K = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    R = eye(3) + sin(phi) * K + (1 - cos(phi)) * (K * K);
end

% Function to apply final rotation matrix
function S = fnRotirajZMatriko(S, R)
    S = S * R;
end