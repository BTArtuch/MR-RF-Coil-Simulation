function [B_x, B_y, B_z, X, Y, Z] = calcSolenoidB1(current, radius, length, N_turns, grid_size)
% 1. Define the 3D spatial grid
x = linspace(-grid_size, grid_size, 50);
y = linspace(-grid_size, grid_size, 50);
z = linspace(-grid_size, grid_size, 50);
[X, Y, Z] = meshgrid(x, y, z);

% 2. Initialize magnetic field arrays
B_x = zeros(size(X));
B_y = zeros(size(Y));
B_z = zeros(size(Z));
mu_0 = 4 * pi * 10^-7;

% 3. Discretize the helical wire path
N_segments_per_turn = 50;
total_segments = N_turns * N_segments_per_turn;

% t represents the total angular rotation across all turns
t = linspace(0, 2*pi*N_turns, total_segments + 1);
dt = t(2) - t(1);

% Calculate Z-axis pitch (longitudinal distance between each turn)
pitch = length / N_turns;

% 4. Biot-Savart Integration Loop
for i = 1:total_segments
    % Midpoint of the segment for integration
    theta = t(i) + dt/2;

    % Source coordinates (Helical path centered at z = 0)
    x_source = radius * cos(theta);
    y_source = radius * sin(theta);
    z_source = (pitch * theta / (2*pi)) - (length / 2);

    % Vector dl components
    dl_x = -radius * sin(theta) * dt;
    dl_y = radius * cos(theta) * dt;
    dl_z = (pitch / (2*pi)) * dt;

    % Distance vectors
    r_x = X - x_source;
    r_y = Y - y_source;
    r_z = Z - z_source;
    r_mag3 = (r_x.^2 + r_y.^2 + r_z.^2).^(3/2);

    % Spatial Cross Product
    cross_x = dl_y .* r_z - dl_z .* r_y;
    cross_y = dl_z .* r_x - dl_x .* r_z;
    cross_z = dl_x .* r_y - dl_y .* r_x;

    % Accumulate B-field
    constant = (mu_0 * current) / (4 * pi);
    B_x = B_x + constant .* (cross_x ./ r_mag3);
    B_y = B_y + constant .* (cross_y ./ r_mag3);
    B_z = B_z + constant .* (cross_z ./ r_mag3);
end
end