disp('Simulation Started')

% % % Get Planet Parameters
planet

% % % Initial Conditions
altitude = 394289; % ISS orbit meterrs
x0 = R+altitude; 
y0 = 0;
z0 = 0;
xdot0 = 0;
inclination = 51.4;
semi_major = norm([x0; y0; z0]);
vcircular = sqrt(mu/semi_major);
ydot0 = vcircular*cos(inclination);
zdot0 = vcircular*sin(inclination);

% % Inital conditions for Attitude and Angular Velocity
phi0 = 0;
theta0 = 0;
psi0 = 0;
ptp0= [phi0, theta0, psi0];



stateinitial = [x0, y0, z0,xdot0, ydot0, zdot0];

% Need time window

period = 2*pi/sqrt(mu)*semi_major^(3/2);
number_of_orbits = 1;
tspan = [0 period*number_of_orbits];

% need to give it derivative function
% time window
% initial conditions
[tout, stateout] = ode45(@Satellite, tspan, stateinitial);

% convert state to km
stateout = stateout/1000;


% Extract the state vector
xout = stateout(:,1);
yout = stateout(:,2);
zout = stateout(:,3);

% Make an Earth
[X,Y,Z] = sphere;
X = X*R/1000; %in KM
Y = Y*R/1000;
Z = Z*R/1000;

% % % Plot 3d orbit
fig = figure();
set(fig, 'color', 'white');
plot3(xout, yout, zout, 'b-', 'LineWidth', 4);

grid on
hold on
mesh(X,Y,Z);
axis equal
