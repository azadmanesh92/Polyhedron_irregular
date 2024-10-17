# Polyhedron_irregular
This MATLAB code generates a 3D visualization of a rough polyhedral model resembling the asteroid 433 Eros. 
Below is a breakdown of what each part of the code does:

Code Breakdown
Environment Setup:

 
clc; % Clears the command window
clear; % Removes all variables from the workspace
close all; % Closes all figures
Random Vertex Generation:

 
num_vertices = 1000; % The number of vertices to create

% Generate random vertices to create a polyhedral shape
x = randn(num_vertices, 1); % X-coordinates from a normal distribution
y = randn(num_vertices, 1); % Y-coordinates from a normal distribution
z = randn(num_vertices, 1); % Z-coordinates from a normal distribution
Random coordinates are generated in 3D space to form the initial vertices of an irregular shape.
Normalization and Elongation:

 
scale_factor = [1.2, 0.8, 0.5]; % Scaling factors to alter the shape
points = [x * scale_factor(1), y * scale_factor(2), z * scale_factor(3)]; 
The generated points are scaled differently along the x, y, and z axes to create an elongated ellipsoid shape, mimicking more the irregular shape of an asteroid.
Constructing the Convex Hull:

 
K = convhull(points); % Computes the convex hull to create a polyhedral surface
The convhull function calculates the smallest convex surface that can enclose the generated points.
Creating the Figure and Plotting:

 
figure; % Creates a new figure window
hold on; % Allows multiple plots in the same figure

% Plotting the convex hull
surf_handle = trisurf(K, points(:,1), points(:,2), points(:,3), 'FaceColor', [0.5 0.5 0.8], 'EdgeColor', 'none');
axis equal tight; % Sets axis properties
grid on; % Turns on the grid
view(3); % Sets the default view to 3D
title('3D Polyhedral Model of Asteroid 433 Eros'); % Sets the title
xlabel('X-axis'); % Labels X-axis
ylabel('Y-axis'); % Labels Y-axis
zlabel('Z-axis'); % Labels Z-axis
Visual Enhancements:

 
lighting gouraud; % Sets lighting for 3D surfaces
camlight('headlight'); % Adds a light source to the camera
material shiny; % Sets the material properties to shiny

rotate3d on; % Enables rotate functionality
Adding a Text Annotation:

 
text_handle = text(0, 0, 0, '', 'Color', 'red', 'FontSize', 12, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');
Initializes a text handle at a specified position to display gravity information, but initially set to empty.
Mouse Motion Callback:

 
set(gcf, 'WindowButtonMotionFcn', @(src, event) mouseMove(src, points, text_handle));
Sets a callback for mouse movement, linking the mouse position to the mouseMove function, which will update the displayed gravity when the mouse moves.
Mouse Movement Handler Function
 
function mouseMove(~, points, text_handle)
   % Gets the current mouse position and calculates the nearest vertex.
   mouse_pos = get(gca, 'CurrentPoint'); 
   mouse_x = mouse_pos(1, 1);
   mouse_y = mouse_pos(1, 2);
   
   % Calculates the nearest point via distances
   distances = sqrt((points(:, 1) - mouse_x).^2 + (points(:, 2) - mouse_y).^2);
   [~, nearest_idx] = min(distances);
   
   % Calculates gravitational force based on a simple model
   G = 6.67430e-11; % Gravitational constant
   M = 5.4e11; % Mass of the asteroid
   r = norm(points(nearest_idx, :)); % Distance from the center

   % Computes gravitational acceleration
   if r > 0
       gravity = G * M / r^2; % Gravity calculation
   else
       gravity = 0; % To avoid division by zero
   end

   % Updates the text to display the gravity value
   set(text_handle, 'Position', [0.95, 0.95, 0], 'String', sprintf('Gravity: %.2e m/s^2', gravity));
end
This function is triggered when the mouse moves over the figure. It calculates the nearest point (vertex) to the mouse position and then computes the gravitational force at that position based on an arbitrarily defined model. It updates the annotation text to show the calculated gravitational acceleration.
