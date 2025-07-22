% Create map
map = binaryOccupancyMap(10, 10, 20); % 10x10 map, 20 cells/meter

% Define some obstacles
setOccupancy(map, [3 3; 3 4; 3 5; 4 5; 5 5], 1); % obstacle region

% Show the map
figure;
show(map);
title('Occupancy Map with Obstacles');

% Define PRM planner
prm = mobileRobotPRM;
prm.Map = map;
prm.NumNodes = 100;
prm.ConnectionDistance = 2;

% Define start and goal
startLocation = [1, 1];
endLocation = [9, 9];

% Plan the path
path = findpath(prm, startLocation, endLocation);

% Retry planning if path not found
while isempty(path)
    prm.NumNodes = prm.NumNodes + 50;
    path = findpath(prm, startLocation, endLocation);
end

% Show path
hold on;
plot(path(:,1), path(:,2), 'r-', 'LineWidth', 2);

%% Differential Drive Robot Simulation
% Setup robot
robotRadius = 0.2;

% Define robot's initial pose [x, y, theta]
robotPose = [startLocation, 0];

% Setup controller
controller = controllerPurePursuit;
controller.Waypoints = path;
controller.DesiredLinearVelocity = 0.6;
controller.MaxAngularVelocity = 1.5;
controller.LookaheadDistance = 0.5;

% Simulation parameters
sampleTime = 0.1;              % Time step
vizRate = rateControl(1/sampleTime);
goalRadius = 0.1;
distanceToGoal = norm(robotPose(1:2) - endLocation);

% Create figure for visualization
figure;
show(map);
hold on;
plot(path(:,1), path(:,2), 'k--')
robotMarker = plot(robotPose(1), robotPose(2), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

% Simulate robot following the path
while distanceToGoal > goalRadius
    % Compute controller outputs
    [v, omega] = controller(robotPose);

    % Update robot pose using differential drive kinematics
    theta = robotPose(3);
    robotPose(1) = robotPose(1) + v * cos(theta) * sampleTime;
    robotPose(2) = robotPose(2) + v * sin(theta) * sampleTime;
    robotPose(3) = robotPose(3) + omega * sampleTime;

    % Update goal distance
    distanceToGoal = norm(robotPose(1:2) - endLocation);

    % Update plot
    robotMarker.XData = robotPose(1);
    robotMarker.YData = robotPose(2);

    waitfor(vizRate);
end

title('Differential Drive Robot Navigation using PRM Path');
