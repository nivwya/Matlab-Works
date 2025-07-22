% Create a binary occupancy map
map = binaryOccupancyMap(10, 10, 10); % 10x10 meters, resolution 10 cells/meter

% Define some obstacles
setOccupancy(map, [3 3; 3 4; 3 5; 4 5; 5 5], 1); % Set these cells as occupied

% Define start and goal positions
start = [1 1];
goal = [8 8];

% Visualize the map
figure;
show(map);
hold on;
plot(start(1), start(2), 'go', 'MarkerSize',10, 'LineWidth',2); % Start - green
plot(goal(1), goal(2), 'rx', 'MarkerSize',10, 'LineWidth',2);   % Goal - red

%% A* Path Planning
planner = plannerAStarGrid(map);
[pathAStar, solnInfo] = plan(planner, start, goal);

if ~isempty(pathAStar)
    % Plot A* path
    plot(pathAStar(:,1), pathAStar(:,2), 'b-', 'LineWidth',2);
else
    disp('A* failed to find a path.');
end

%% RRT Path Planning
% Set up state space and validator
ss = stateSpaceSE2;
sv = validatorOccupancyMap(ss);
sv.Map = map;
sv.ValidationDistance = 0.1;

% Define bounds for planning
ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];

% Create RRT planner
rrt = plannerRRT(ss, sv);
rrt.MaxConnectionDistance = 1.0;
rrt.MaxIterations = 3000;

% Plan with RRT
[rrtPath, ~] = plan(rrt, [start 0], [goal 0]);

% Plot RRT path (if found)
if ~isempty(rrtPath)
    plot(rrtPath.States(:,1), rrtPath.States(:,2), 'm--', 'LineWidth',2);
    legend('Map', 'Start', 'Goal', 'A* Path', 'RRT Path');
else
    disp('RRT failed to find a path.');
end

title('A* and RRT Motion Planning');
