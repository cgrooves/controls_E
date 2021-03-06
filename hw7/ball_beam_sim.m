% clear everything
clear; close; clc;

% add parent dir to path
addpath ./..
ball_beam_params

% create dynamics object
dynamics = BallBeamDynamics(P);

% Create input for force
ballBeam = BallBeam_gui;
handles = guidata(ballBeam);
ax = handles.plot1;

% create animation object
animation = BallBeamAnimation(P,ax);
control = BBControl(P);

z = [0;0]';

z_ref_signal = signalGenerator(.25,.001); % square wave input
rnd_signal = signalGenerator(.15,.01);

plt = DynamicPlotData(P,'Force (N)','Ball Position (m)');

t = 0;

% while forever
while isgraphics(ballBeam)
    
    % get input values
    z_ref = z_ref_signal.square(t);
    
    % calculate input force
    f = control.u(z_ref,z(1),z(2));
    
    % propagate the dynamics
    dynamics.propagateDynamics(f);

    % update the animation
    z = dynamics.output();    
    
    % draw the animation
    animation.draw(z);
    plt.update(f,z(1));
    pause(P.Ts);
    
    t = t + P.Ts; % increment time
    
end