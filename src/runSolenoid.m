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

% Extract a 2D coronal slice through the center of the coil (Y = 0)
slice_index = 25; 
X_slice = squeeze(X(slice_index, :, :));
Z_slice = squeeze(Z(slice_index, :, :));
B_slice = squeeze(B_mag(slice_index, :, :));

% Plot the homogeneous field along the Z-axis
figure('Position', [100, 100, 700, 600]);
contourf(X_slice, Z_slice, B_slice, 50, 'LineColor', 'none');
colorbar;
colormap('jet');
hold on;

% Overlay the physical coil windings for context (approximate crossing points at Y=0)
cross_z = linspace(-length/2, length/2, N_turns);
plot(radius*ones(1, N_turns), cross_z, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 6);
plot(-radius*ones(1, N_turns), cross_z, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 6);

title('Phase 2.1: Coronal B_1 Field of a Solenoid Coil');
xlabel('X Position (m)');
ylabel('Z Position (m)');

% --- Output Management ---
% 1. Save binary data to git-ignored output folder
out_dir = 'output';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end
save(fullfile(out_dir, 'Solenoid_Data.mat'), 'B_x', 'B_y', 'B_z', 'X', 'Y', 'Z', 'B_mag');

% 2. Save high-resolution plot to version-controlled assets folder
assets_dir = 'assets';
if ~exist(assets_dir, 'dir')
    mkdir(assets_dir);
end
exportgraphics(gcf, fullfile(assets_dir, 'Solenoid_Homogeneity.png'), 'Resolution', 300);

disp('Simulation complete. Image routed to /assets/ and binary to /output/.');