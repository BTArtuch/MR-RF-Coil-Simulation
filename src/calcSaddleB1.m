function [B_x, B_y, B_z, X, Y, Z] = calcSaddleB1(current, radius, length, grid_size)
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

% 3. Saddle Geometry Parameters
span = 2*pi/3; % 120-degree optimal span
half_span = span / 2;
centers = [0, pi]; % Center angles for Saddle 1 and Saddle 2

N_arc = 30;
N_leg = 30;

% 4. Integration Loop for both saddles
for c = 1:2
    phi = centers(c);

    % --- Segment 1 & 2: Top and Bottom Arcs ---
    theta = linspace(phi - half_span, phi + half_span, N_arc);
    d_theta = theta(2) - theta(1);
    z_arcs = [length/2, -length/2];
    current_dir_arc = [1, -1]; % Opposite current flow top vs bottom

    for arc = 1:2
        for i = 1:(N_arc-1)
            t = theta(i) + d_theta/2;
            x_source = radius * cos(t);
            y_source = radius * sin(t);
            z_source = z_arcs(arc);

            dl_x = -radius * sin(t) * d_theta * current_dir_arc(arc);
            dl_y = radius * cos(t) * d_theta * current_dir_arc(arc);
            dl_z = 0;

            [B_x, B_y, B_z] = addBiotSavart(B_x, B_y, B_z, X, Y, Z, x_source, y_source, z_source, dl_x, dl_y, dl_z, current, mu_0);
        end
    end

    % --- Segment 3 & 4: Straight Legs ---
    z_legs = linspace(-length/2, length/2, N_leg);
    dz = z_legs(2) - z_legs(1);
    theta_legs = [phi + half_span, phi - half_span];
    current_dir_leg = [-1, 1]; % Opposite current flow left vs right leg

    for leg = 1:2
        x_source = radius * cos(theta_legs(leg));
        y_source = radius * sin(theta_legs(leg));

        for j = 1:(N_leg-1)
            z_source = z_legs(j) + dz/2;

            dl_x = 0;
            dl_y = 0;
            dl_z = dz * current_dir_leg(leg);

            [B_x, B_y, B_z] = addBiotSavart(B_x, B_y, B_z, X, Y, Z, x_source, y_source, z_source, dl_x, dl_y, dl_z, current, mu_0);
        end
    end
end
end

% Local helper function to apply the cross product cleanly
function [B_x, B_y, B_z] = addBiotSavart(B_x, B_y, B_z, X, Y, Z, xs, ys, zs, dl_x, dl_y, dl_z, I, mu_0)
r_x = X - xs;
r_y = Y - ys;
r_z = Z - zs;
r_mag3 = (r_x.^2 + r_y.^2 + r_z.^2).^(3/2);

cross_x = dl_y .* r_z - dl_z .* r_y;
cross_y = dl_z .* r_x - dl_x .* r_z;
cross_z = dl_x .* r_y - dl_y .* r_x;

constant = (mu_0 * I) / (4 * pi);
B_x = B_x + constant .* (cross_x ./ r_mag3);
B_y = B_y + constant .* (cross_y ./ r_mag3);
B_z = B_z + constant .* (cross_z ./ r_mag3);
end