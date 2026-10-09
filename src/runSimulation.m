% Set physical parameters: 1 Ampere, 5 cm radius loop, 10 cm mapping grid
current = 1.0;
radius = 0.05;
grid_size = 0.10;

% Call your custom solver
[B_x, B_y, B_z, X, Y, Z] = calcBiotSavart(current, radius, grid_size);

% Calculate the magnitude of the B1 field
B_mag = sqrt(B_x.^2 + B_y.^2 + B_z.^2);

% Extract a 2D slice through the center of the coil (y = 0)
slice_index = 25; 
X_slice = squeeze(X(slice_index, :, :));
Z_slice = squeeze(Z(slice_index, :, :));
B_slice = squeeze(B_mag(slice_index, :, :));

% Plot the rapid field decay
figure;
contourf(X_slice, Z_slice, B_slice, 50, 'LineColor', 'none');
colorbar;
colormap('jet');
title('Phase 1: B_1 Field Magnitude Drop-Off (Surface Coil)');
xlabel('X Position (m)');
ylabel('Depth into Tissue (Z Position) (m)');

% --- Output Management ---

% Define the target output directory
out_dir = 'output';

% Check if the directory exists; if not, create it
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

% Save the 2D slice heatmap as a high-resolution PNG
fig_path = fullfile(out_dir, 'B1_Field_Dropoff.png');
exportgraphics(gcf, fig_path, 'Resolution', 300);

% Save the raw 3D spatial and magnetic field matrices
data_path = fullfile(out_dir, 'B1_Simulation_Data.mat');
save(data_path, 'B_x', 'B_y', 'B_z', 'X', 'Y', 'Z', 'B_mag');

fprintf('Simulation complete. Results automatically saved to /%s/\n', out_dir);