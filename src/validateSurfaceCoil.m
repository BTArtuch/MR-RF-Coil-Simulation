clearvars; % Clear old variables to prevent shadowing

% 1. Set identical physical parameters
radius = 0.05;
current = 1.0;
grid_size = 0.10;
freq = 128e6; % 128 MHz (3T MRI Larmor Frequency)
mu_0 = 4 * pi * 10^-7;

% 2. Define probe points straight down the Z-axis (1cm to 10cm depth)
z_depths = linspace(0.01, grid_size, 20); 
points = [zeros(1, numel(z_depths)); zeros(1, numel(z_depths)); z_depths]; 

% 3. Proprietary Toolbox Calculation
disp('Calculating near-field with Antenna Toolbox...');
toolboxCoil = loopCircular('Radius', radius);
[~, H] = EHfields(toolboxCoil, freq, points);

% Convert H-field (A/m) to B-field (T) and normalize
B_toolbox = mu_0 * vecnorm(H); 
B_toolbox_norm = B_toolbox / max(B_toolbox);

% 4. Custom Biot-Savart Calculation
disp('Calculating near-field with Custom Biot-Savart Engine...');
[B_x, B_y, B_z, X, Y, Z] = calcBiotSavart(current, radius, grid_size);
B_mag_custom = sqrt(B_x.^2 + B_y.^2 + B_z.^2);

% Interpolate the custom 3D grid data precisely along the Z-axis probe points
B_custom_line = interp3(X, Y, Z, B_mag_custom, zeros(1, 20), zeros(1, 20), z_depths);
B_custom_norm = B_custom_line / max(B_custom_line);

% 5. Plot the Validation Comparison
figure('Position', [100, 100, 700, 500]);
plot(z_depths, B_custom_norm, 'b-', 'LineWidth', 2);
hold on;
plot(z_depths, B_toolbox_norm, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');

legend('Custom Biot-Savart Engine', 'Proprietary Antenna Toolbox');
title('Validation: Surface Coil B_1 Field Decay Profile');
xlabel('Depth into Tissue (Z-axis in meters)');
ylabel('Normalized B_1 Field Magnitude');
grid on;

% --- Root-Directed Output Management ---
% Calculate the absolute path to this script, then step up one level to the root
src_dir = fileparts(mfilename('fullpath'));
root_dir = fullfile(src_dir, '..');
assets_dir = fullfile(root_dir, 'assets');

if ~exist(assets_dir, 'dir')
    mkdir(assets_dir);
end

exportgraphics(gcf, fullfile(assets_dir, 'Validation_SurfaceCoil.png'), 'Resolution', 300);
disp('Validation complete. Plot routed to /assets/ at the project root.');