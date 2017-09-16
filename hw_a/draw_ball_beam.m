function draw_ball_beam(handles,flag)
	global R;
    global L;

    % Get input
    z = get(handles.z_slider,'Value')
    theta = get(handles.theta_slider,'Value');
    
    % Transform coordinates
    beam_pts = [0, L;
        0, 0];

    ball_pt = [z, R];
    R_matrix = [cos(theta), -sin(theta);
        sin(theta), cos(theta)];
    ball_pt = (R_matrix*ball_pt')';
    beam_pts = R_matrix*beam_pts;
    
    
    persistent ball;
    persistent beam;
    
%       hold on
    cla
    set(handles.axes1,'XLim',[-2*L,2*L],'YLim',[-2*L,2*L]);
    ball = viscircles(ball_pt,R);
    beam = line(handles.axes1,beam_pts(1,:),beam_pts(2,:)); 
    set(beam,'XData',beam_pts(1,:),'YData',beam_pts(2,:))
    viscircles(ball_pt,R);

end