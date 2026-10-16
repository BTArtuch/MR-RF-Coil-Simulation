clearvars; % Clear old variables to prevent shadowing

% Set physical parameters: 1 Amp, 5cm radius, 15cm length, 10 turns
current = 1.0;
radius = 0.05;
length = 0.15;
N_turns = 10;
grid_size = 0.15;

disp('Simulating Solenoid Volume Coil...');
[B_x, B_y, B_z, X, Y, Z] = calcSolenoidB1(current, radius, length, N_turns, grid_size);

% Calculate the magnitude of the B1 field
B_mag = sqrt(B_x.^2 + B_y.^2 + B_z.^2);

% Extract a 2D transverse slice through the dead-center of the coil (Z = 0)
slice_index = 25; 
X_slice = squeeze(X(:, :, slice_index));
Y_slice = squeeze(Y(:, :, slice_index));
B_slice = squeeze(B_mag(:, :, slice_index));

% Plot the homogeneous field along the X-Y plane
figure('Position', [100, 100, 700, 600]);
contourf(X_slice, Y_slice, B_slice, 50, 'LineColor', 'none');
colorbar;
colormap('jet');
hold on;

% Overlay the physical coil boundary for context (Top-down view of the cylinder)
theta_circ = linspace(0, 2*pi, 100);
plot(radius*cos(theta_circ), radius*sin(theta_circ), 'w--', 'LineWidth', 2);

title('Phase 2.1: Transverse B_1 Field of a Solenoid Coil');
xlabel('X Position (m)');
ylabel('Y Position (m)');
axis equal;

% --- Root-Directed Output Management ---
% Calculate the absolute path to this script, then step up one level to the root
src_dir = fileparts(mfilename('fullpath'));
root_dir = fullfile(src_dir, '..');

out_dir = fullfile(root_dir, 'output');
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end
save(fullfile(out_dir, 'Solenoid_Data.mat'), 'B_x', 'B_y', 'B_z', 'X', 'Y', 'Z', 'B_mag');

assets_dir = fullfile(root_dir, 'assets');
if ~exist(assets_dir, 'dir')
    mkdir(assets_dir);
end
exportgraphics(gcf, fullfile(assets_dir, 'Solenoid_Homogeneity_Transverse.png'), 'Resolution', 300);

disp('Simulation complete. Transverse plot routed to /assets/ at the project root.');