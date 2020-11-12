function dstatedt = Satellite(t, state)

% stateinitial = [x0, y0, z0,xdot0, ydot0, zdot0];
% x = state(1);
% y = state(2);
% z = state(3);
% xdot = state(4);
% ydot = state(5);
% zdot = state(6);

m = 2.6; %kg

% % %  Kinematics
vel = state(4:6);

% % % Gravity Model
planet
r = state(1:3); %% x y z
rnorm = norm(r);
rhat = r/rnorm;
Fgrav= -(G*M*m/rnorm^2)*rhat;

% % %  Dynamics
F = Fgrav; %we're only using gravity 
accel = F/m;

dstatedt = [vel;accel];
