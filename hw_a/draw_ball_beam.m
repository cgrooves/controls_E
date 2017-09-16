function draw_ball_beam(handles)
	ball_paramsHWA
    
    % Get input
    z = get(handles.z_slider,'Value');
    theta = get(handles.theta_slider,'Value');
    
    % Transform coordinates
    beam_pts = [0, L*cos(theta);
        0, L*sin(theta)];
    
    ball_pt = [z*cos(theta), z*sin(theta)]';
    
    % Draw beam and ball
    viscircles(handles.axes1,ball_pt,R);
    line(handles.axes1,beam_pts(1,:),beam_pts(2,:))
    set(handles.axes1,'XLim',[-L, 3*L],'YLim',[-2*L,2*L]);
    
end