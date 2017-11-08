% Ball/Beam parameters
P.m1 = 0.35; % kg, mass of the ball
P.m2 = 2; % kg, mass of the beam
P.l = 0.5; % m, length of the beam
P.g = 9.8; % m/s^2, gravity constant

P.var = 0.0; % uncertainty parameter, affects m1, m2, l

% Ball/Beam Sim Parameters
P.R = 0.1;
P.Length = 1;

P.ze = P.l/2;

% Initial conditions
P.z0 = P.ze;
P.zdot0 = 0;
P.theta0 = 0;
P.thetadot0 = 0;

P.f_init = P.g/2*(P.m1 + P.m2); % equilibrium force
P.f_max = P.f_init * 1.1;
P.f_min = P.f_init * -1.1;

P.z_max = P.l;
P.z_min = 0;

P.Ts = 0.01; % simulation time step

% Controls

% Manual control gain values
% P.kp_theta = 1.8251;
% P.kd_theta = 1.1730;
% P.kp_z = -0.0049;
% P.kd_z = -0.0317;

P.sat_limit = [-15,15];
P.tau = 0.05; % dirty derivative time constant

P.zeta_theta = .707;
P.tr_theta = .153; % PID value: .153
P.wn_theta = 2.2/P.tr_theta;

P.zeta_z = .707;
P.tr_z = 10*P.tr_theta;
P.wn_z = 2.2/P.tr_z;

% auto calculated gains
P.theta_gains.kP = (P.m1*P.ze^2+P.m2*P.l^2/3)/P.l*(2.2/P.tr_theta)^2;
P.theta_gains.kD = (P.m1*P.ze^2+P.m2*P.l^2/3)*4.4*P.zeta_theta/(P.l*P.tr_theta);

P.z_gains.kP = -1/P.g*(2.2/(10*P.tr_theta))^2;
P.z_gains.kD = -4.4*P.zeta_z/(10*P.g*P.tr_theta);
P.z_gains.kI = -0.09;

%% State feedback param's
P.a = 1/(P.m1*P.ze^2 + P.m2*P.l^2/3);
P.A = [0 0 1 0;
    0 0 0 1;
    0 -P.g 0 0;
    -P.m1*P.g*P.a 0 0 0];
P.B = [0 0 0 P.a*P.l]';
P.Cr = [1 0 0 0];
P.D = 0;

P.C_ab = ctrb(P.A,P.B);

P.p = roots([1,2*(P.zeta_theta*P.wn_theta+P.zeta_z+P.wn_z), P.wn_z^2 + ...
    P.wn_theta^2 + 4*P.zeta_theta*P.zeta_z*P.wn_z*P.wn_theta, ...
    2*(P.zeta_theta*P.wn_z^2*P.wn_theta + P.zeta_z*P.wn_theta^2*P.wn_z),...
    P.wn_z^2*P.wn_theta^2]);

P.K = place(P.A,P.B,P.p);
%P.K = [-23.31 94.333 -17.7929 9.2845];
P.kr = -1/(P.Cr*((P.A-P.B*P.K)\P.B));
%P.kr = 166.18;
