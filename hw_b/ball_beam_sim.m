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
f_slider = handles.force_slider;

% set slider values
set(f_slider,'Min',-P.f_max,'Max',P.f_max,'Value',P.f_init);

% create animation object
animation = BallBeamAnimation(P,ax);

% while forever
while isgraphics(ballBeam)
    
    % get input values
    f = get(f_slider,'Value');
    % propagate the dynamics
    dynamics.propagateDynamics(f);
    % update the animation
    y = dynamics.output();
    
    % reset ball if it falls too far
    if y(1) < -5*P.Length || y(1) > 5*P.Length
        dynamics.reset();
        set(f_slider,'Value',P.f_init);
    end
    
    % draw the animation
    animation.draw(y);
    pause(0.08);
    
end