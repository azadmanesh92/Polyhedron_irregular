

clc;
clear;
close all;

% Number of vertices
num_vertices = 1000;

% Generate random vertices for a rough polyhedral shape
% Define arbitrary ranges for the coordinates to emulate the Eros shape
x = randn(num_vertices, 1);
y = randn(num_vertices, 1);
z = randn(num_vertices, 1);

% Normalize the vertices to create a more asteroid-like shape (elongated ellipsoid)
scale_factor = [1.2, 0.8, 0.5]; % Example scaling factors to elongate in x and y
points = [x * scale_factor(1), y * scale_factor(2), z * scale_factor(3)];

% Perform convex hull to create a polyhedral surface
K = convhull(points);

% Create the figure
figure;
hold on;

% Plot the convex hull (polyhedron)
surf_handle = trisurf(K, points(:,1), points(:,2), points(:,3), 'FaceColor', [0.5 0.5 0.8], 'EdgeColor', 'none');
axis equal tight; % Use 'tight' for a better fit to the data
grid on;
view(3);
title('3D Polyhedral Model of Asteroid 433 Eros');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');

% Set view properties for better visualization
lighting gouraud;
camlight('headlight');
material shiny;

% Enable rotation
rotate3d on;

% Add an annotation text object for showing gravity
text_handle = text(0, 0, 0, '', 'Color', 'red', 'FontSize', 12, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');

% Mouse motion callback
set(gcf, 'WindowButtonMotionFcn', @(src, event) mouseMove(src, points, text_handle));

hold off; % Move hold off before the function definition

% Function to handle mouse movement
function mouseMove(~, points, text_handle)
    % Get the current point in 3D coordinates
    mouse_pos = get(gca, 'CurrentPoint'); 
    mouse_x = mouse_pos(1, 1);
    mouse_y = mouse_pos(1, 2);
    
    % Calculate nearest point using the projected 2D coordinates
    distances = sqrt((points(:, 1) - mouse_x).^2 + (points(:, 2) - mouse_y).^2);
    [~, nearest_idx] = min(distances);
    
    % Assume a simple gravity model for illustration
    G = 6.67430e-11; % Gravitational constant in m^3 kg^-1 s^-2
    M = 5.4e11; % Mass of the asteroid in kg (example value)
    
    % Calculate the gravitational force
    r = norm(points(nearest_idx, :)); % Distance from the center
    if r > 0 % Prevent division by zero
        gravity = G * M / r^2; % Gravitational acceleration (approximation)
    else
        gravity = 0; % If the distance is zero, set gravity to zero to avoid NaN
    end

    % Update text position and value
    set(text_handle, 'Position', [0.95, 0.95, 0], 'String', sprintf('Gravity: %.2e m/s^2', gravity));
end