
clearvars;

% Define clinical MRI field strengths (0.5T to 7T) and Larmor frequencies
B0_range = linspace(0.5, 7, 100); % Tesla
gamma = 42.58e6; % Gyromagnetic ratio for Hydrogen (Hz/T)
freq_range = gamma .* B0_range;
c = 3e8; % Speed of light (m/s)
lambda = c ./ freq_range;

% Coil Dimension (Standard Head Birdcage)
D = 0.30; % 30 cm diameter

% Calculate Boundaries
fraunhofer_dist = (2 * D^2) ./ lambda; % Electrically Large
radiansphere = lambda ./ (2 * pi);     % Electrically Small

% Plot the Near-Field Proof
figure('Position', [100, 100, 700, 500]);
plot(B0_range, radiansphere, 'b-', 'LineWidth', 2); hold on;
% plot(B0_range, fraunhofer_dist, 'r--', 'LineWidth', 2);
yline(D/2, 'k:', 'LineWidth', 1.5, 'Label', 'Physical Coil Radius (Patient Zone)','LabelVerticalAlignment', 'bottom');

title('MR RF Coil Simulation: Near-Field Confinement Proof');
xlabel('Main Magnetic Field B_0 (Tesla)');
ylabel('Boundary Distance (meters)');
legend('Near-Field Boundary (\lambda / 2\pi)');
grid on;

% --- Output Management ---
src_dir = fileparts(mfilename('fullpath'));
root_dir = fullfile(src_dir, '..');
assets_dir = fullfile(root_dir, 'assets');

if ~exist(assets_dir, 'dir')
    mkdir(assets_dir);
end
exportgraphics(gcf, fullfile(assets_dir, 'NearField_Proof.png'), 'Resolution', 300);
disp('Proof complete. Plot routed to /assets/.');