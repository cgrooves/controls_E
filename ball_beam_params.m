% Ball/Beam parameters
P.m1 = 0.35; % kg, mass of the ball
P.m2 = 2; % kg, mass of the beam
P.l = 0.5; % m, length of the beam
P.g = 9.8; % m/s^2, gravity constant

% Ball/Beam Sim Parameters
P.R = 0.1;
P.Length = 2;

% Initial conditions
P.z0 = P.l/2;
P.zdot0 = 0;
P.theta0 = 0;
P.thetadot0 = 0;

P.f_init = P.g/2*(P.m1 + P.m2); % equilibrium force
P.f_max = P.f_init * 1.1;
P.f_min = P.f_init * -1.1;

P.Ts = 0.1; % simulation time step