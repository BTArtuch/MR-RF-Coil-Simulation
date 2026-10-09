% Set physical parameters: 1 Amp, 15cm radius (head size), 30cm length, 16 rungs
I_0 = 1.0;
radius = 0.15;
length = 0.30;
N_rungs = 16;
grid_size = 0.20;

disp('Simulating 16-Rung Birdcage Volume Coil...');
[B_x, B_y, B_z, X, Y, Z] = calcBirdcageB1(I_0, radius, length, N_rungs, grid_size);

% Calculate the magnitude of the B1 field
B_mag = sqrt(B_x.^2 + B_y.^2 + B_z.^2);

% Extract a 2D transverse slice through the dead-center of the coil (Z = 0)
slice_index = 25; 
X_slice = squeeze(X(:, :, slice_index));
Y_slice = squeeze(Y(:, :, slice_index));
B_slice = squeeze(B_mag(:, :, slice_index));

% Plot the homogeneous field
figure('Position', [100, 100, 700, 600]);
contourf(X_slice, Y_slice, B_slice, 50, 'LineColor', 'none');
colorbar;
colormap('jet');
hold on;

% Overlay the physical rung locations for context
rung_x = radius * cos(linspace(0, 2*pi, N_rungs+1));
rung_y = radius * sin(linspace(0, 2*pi, N_rungs+1));
plot(rung_x, rung_y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 6);

title('Phase 2: Transverse B_1 Field of a 16-Rung Birdcage Coil');
xlabel('X Position (m)');
ylabel('Y Position (m)');
axis equal;

% --- Output Management ---
out_dir = 'output';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

exportgraphics(gcf, fullfile(out_dir, 'Birdcage_Homogeneity.png'), 'Resolution', 300);
save(fullfile(out_dir, 'Birdcage_Data.mat'), 'B_x', 'B_y', 'B_z', 'X', 'Y', 'Z', 'B_mag');
disp('Phase 2 results saved to /output/');