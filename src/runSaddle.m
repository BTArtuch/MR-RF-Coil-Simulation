% Set physical parameters
current = 1.0;
radius = 0.15;
length = 0.30;
grid_size = 0.20;

disp('Simulating 120-Degree Two-Saddle Coil...');
[B_x, B_y, B_z, X, Y, Z] = calcSaddleB1(current, radius, length, grid_size);

% Calculate the magnitude of the B1 field
B_mag = sqrt(B_x.^2 + B_y.^2 + B_z.^2);

% Extract a 2D transverse slice through the center of the coil (Z = 0)
slice_index = 25; 
X_slice = squeeze(X(:, :, slice_index));
Y_slice = squeeze(Y(:, :, slice_index));
B_slice = squeeze(B_mag(:, :, slice_index));

% Plot the field
figure('Position', [100, 100, 700, 600]);
contourf(X_slice, Y_slice, B_slice, 50, 'LineColor', 'none');
colorbar;
colormap('jet');
hold on;

% Overlay the 4 straight leg locations
span = pi/3;
legs_th = [span, -span, pi+span, pi-span];
plot(radius*cos(legs_th), radius*sin(legs_th), 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 6);

title('Phase 2.2: Transverse B_1 Field of a Two-Saddle Coil');
xlabel('X Position (m)');
ylabel('Y Position (m)');
axis equal;

% --- Output Management ---
out_dir = 'output';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end
save(fullfile(out_dir, 'Saddle_Data.mat'), 'B_x', 'B_y', 'B_z', 'X', 'Y', 'Z', 'B_mag');

assets_dir = 'assets';
if ~exist(assets_dir, 'dir')
    mkdir(assets_dir);
end
exportgraphics(gcf, fullfile(assets_dir, 'Saddle_Homogeneity.png'), 'Resolution', 300);

disp('Simulation complete. Image routed to /assets/ and binary to /output/.');