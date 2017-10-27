% Ball/Beam parameters
P.m1 = 0.35; % kg, mass of the ball
P.m2 = 2; % kg, mass of the beam
P.l = 0.5; % m, length of the beam
P.g = 9.8; % m/s^2, gravity constant

P.var = 0.2; % uncertainty parameter, affects m1, m2, l

% Ball/Beam Sim Parameters
P.R = 0.1;
P.Length = 1;

P.ze = P.l/2;

% Initial conditions
P.z0 = 0;
P.zdot0 = 0;
P.theta0 = 0;
P.thetadot0 = 0;

P.f_init = P.g/2*(P.m1 + P.m2); % equilibrium force
P.f_max = P.f_init * 1.1;
P.f_min = P.f_init * -1.1;

P.z_max = P.l;
P.z_min = 0;

P.Ts = 0.05; % simulation time step

% Controls

% Manual control gain values
% P.kp_theta = 1.8251;
% P.kd_theta = 1.1730;
% P.kp_z = -0.0049;
% P.kd_z = -0.0317;

P.sat_limit = [0,15];

P.zeta_theta = .707;
P.tr_theta = .153;
P.zeta_z = .707;
P.tr_z = 10*P.tr_theta;

% auto calculated gains
P.kp_theta = (P.m1*P.ze^2+P.m2*P.l^2/3)/P.l*(2.2/P.tr_theta)^2;
P.kd_theta = (P.m1*P.ze^2+P.m2*P.l^2/3)*4.4*P.zeta_theta/(P.l*P.tr_theta);

P.kp_z = -1/P.g*(2.2/(10*P.tr_theta))^2;
P.kd_z = -4.4*P.zeta_z/(10*P.g*P.tr_theta);