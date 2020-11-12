%%%Initialize
clear
clc
close all

%%%Globals
global BxI ByI BzI

%%%%Simulation of a Low Earth Satellite
disp('Simulation Started')

%%%Setup the IGRF Model
disp(['You must download the igrf model from MathWorks in order to' ...
      ' use this software'])
disp('https://www.mathworks.com/matlabcentral/fileexchange/34388-international-geomagnetic-reference-field-igrf-model')
addpath '../igrf/'

%%%Get Planet Parameters
planet

%%%Initial Conditions
orbit_angle = 51.4;
altitude = 400*1000; %%meters
x0 = R + altitude;
y0 = 0;
z0 = 0; 
xdot0 = 0;
inclination = orbit_angle*pi/180;
semi_major = norm([x0;y0;z0]);
vcircular = sqrt(mu/semi_major);
ydot0 = vcircular*cos(inclination);
zdot0 = vcircular*sin(inclination);
stateinitial = [x0;y0;z0;xdot0;ydot0;zdot0];

%%%Need time window
period = 2*pi/sqrt(mu)*semi_major^(3/2);
number_of_orbits = 1;
tspan = [0 period*number_of_orbits];

%%%This is where we integrate the equations of motion
[tout,stateout] = ode45(@Satellite,tspan,stateinitial);

%%%Loop through stateout to extract Magnetic Field
BxIout = 0*stateout(:,1);
ByIout = BxIout;
BzIout = BxIout;
for idx = 1:length(tout)
    dstatedt = Satellite(tout(idx),stateout(idx,:));
    BxIout(idx) = BxI;
    ByIout(idx) = ByI;
    BzIout(idx) = BzI;
end

%%%Convert state to kilometers
stateout = stateout/1000;

%%%Extract the state vector
xout = stateout(:,1);
yout = stateout(:,2);
zout = stateout(:,3);

%%%Make an Earth
[X,Y,Z] = sphere(100);
X = X*R/1000;
Y = Y*R/1000;
Z = Z*R/1000;

%%%Plot X,Y,Z as a function of time
fig0 = figure();
set(fig0,'color','white')
plot(tout,xout,'b-','LineWidth',2)
hold on
grid on
plot(tout,yout,'r-','LineWidth',2)
plot(tout,zout,'g-','LineWidth',2)
xlabel('Time (sec)')
ylabel('Position (m)')
legend('X','Y','Z')

%%%Plot 3D orbit
fig = figure();
set(fig,'color','white')
plot3(xout,yout,zout,'b-','LineWidth',4)
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
hold on
surf(X,Y,Z,'EdgeColor','none')
title(['Orbital Trajectory for ' num2str(orbit_angle) ' Inclination'])
axis equal

%%%Plot Magnetic Field
fig2 = figure();
set(fig2,'color','white')
plot(tout,BxIout/1000,'b-','LineWidth',2)
hold on
grid on
plot(tout,ByIout/1000,'r-','LineWidth',2)
plot(tout,BzIout/1000,'g-','LineWidth',2)
xlabel('Time (sec)')
ylabel('Magnetic Field (\muT)')
title(['Magnetic Field For One Orbital Period at ' num2str(orbit_angle) ' degrees'])
legend('X','Y','Z')

%%%And Norm
Bnorm = sqrt(BxIout.^2 + ByIout.^2 + BzIout.^2);
fig3 = figure();
set(fig3,'color','white')
plot(tout,Bnorm/1000,'LineWidth',2)
xlabel('Time (sec)')
ylabel('Magnetic Field (\muT)')
title('Normalized Magnetic Field Vector')
grid on
