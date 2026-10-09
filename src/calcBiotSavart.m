function [B_x, B_y, B_z, X, Y, Z] = calcBiotSavart(current, radius, grid_size)
% 1. Define the 3D spatial grid (Volume of interest)
% We focus on z >= 0 to represent penetration into human tissue later
x = linspace(-grid_size, grid_size, 50);
y = linspace(-grid_size, grid_size, 50);
z = linspace(0.001, grid_size, 50); % Start slightly above 0 to avoid singularity

[X, Y, Z] = meshgrid(x, y, z); 

% 2. Initialize the magnetic field arrays
B_x = zeros(size(X));
B_y = zeros(size(Y));
B_z = zeros(size(Z));

% 3. Define the permeability of free space
mu_0 = 4 * pi * 10^-7;

% 4. Discretize the wire loop into N tiny segments
N_segments = 100;
theta = linspace(0, 2*pi, N_segments + 1);
d_theta = theta(2) - theta(1);

% 5. Biot-Savart Integration Loop
for i = 1:N_segments
    % Midpoint of the current segment for accurate evaluation
    t = theta(i) + d_theta/2; 

    % Source coordinates (Position of the wire segment)
    x_source = radius * cos(t);
    y_source = radius * sin(t);
    z_source = 0; 

    % Vector dl (Length and direction of the segment)
    dl_x = -radius * sin(t) * d_theta;
    dl_y = radius * cos(t) * d_theta;
    dl_z = 0;

    % Distance vectors from source segment to all [X,Y,Z] observation points
    r_x = X - x_source;
    r_y = Y - y_source;
    r_z = Z - z_source;

    % Magnitude cubed: |r|^3
    r_mag3 = (r_x.^2 + r_y.^2 + r_z.^2).^(3/2);

    % Spatial Cross Product: dl x r
    cross_x = dl_y .* r_z - dl_z .* r_y;
    cross_y = dl_z .* r_x - dl_x .* r_z;
    cross_z = dl_x .* r_y - dl_y .* r_x;

    % Calculate dB contribution for this segment and add to total field
    constant = (mu_0 * current) / (4 * pi);
    B_x = B_x + constant .* (cross_x ./ r_mag3);
    B_y = B_y + constant .* (cross_y ./ r_mag3);
    B_z = B_z + constant .* (cross_z ./ r_mag3);
end
end