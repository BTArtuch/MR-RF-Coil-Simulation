function [B_x, B_y, B_z, X, Y, Z] = calcBirdcageB1(I_0, radius, length, N_rungs, grid_size)
% 1. Define the 3D spatial grid (Volume inside and around the cylinder)
x = linspace(-grid_size, grid_size, 50);
y = linspace(-grid_size, grid_size, 50);
z = linspace(-grid_size, grid_size, 50);
[X, Y, Z] = meshgrid(x, y, z); 

% 2. Initialize magnetic field arrays
B_x = zeros(size(X));
B_y = zeros(size(Y));
B_z = zeros(size(Z));
mu_0 = 4 * pi * 10^-7;

% 3. Calculate the angular position of each rung
theta = linspace(0, 2*pi, N_rungs + 1);
theta(end) = []; % Remove 2*pi as it overlaps with 0

% Discretize the straight rungs along the Z-axis
N_z_segments = 50;
z_rungs = linspace(-length/2, length/2, N_z_segments + 1);
dz = z_rungs(2) - z_rungs(1);

% 4. Multi-Wire Biot-Savart Loop
for k = 1:N_rungs
    % The magic of the Birdcage: Phase-shifted current
    % Driving the rungs as a sinusoidal function of their azimuthal angle
    I_k = I_0 * cos(theta(k));

    % X/Y coordinates for this specific rung
    x_source = radius * cos(theta(k));
    y_source = radius * sin(theta(k));

    % Integrate along the length of the rung
    for j = 1:N_z_segments
        z_source = z_rungs(j) + dz/2; % Segment midpoint

        % Vector dl (Current flows purely in the Z direction for the rungs)
        dl_x = 0;
        dl_y = 0;
        dl_z = dz;

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
        constant = (mu_0 * I_k) / (4 * pi);
        B_x = B_x + constant .* (cross_x ./ r_mag3);
        B_y = B_y + constant .* (cross_y ./ r_mag3);
        B_z = B_z + constant .* (cross_z ./ r_mag3);
    end
end
end