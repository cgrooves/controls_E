classdef BallBeamAnimation
    
    properties
        ball_r
        beam_l
        ax
        
        ball
        beam
        
    end
    
    methods
        % Constructor---------------
        function self = BallBeamAnimation(P,plot_axes)
            % include path to graphics objects
            addpath ~/Documents/MATLAB
            
            % initialize variables
            self.ball_r = P.R;
            self.beam_l = P.l;
            self.ax = plot_axes;
            
            % Draw ground on axes
            plot(self.ax,[-P.Length,P.Length],[0,0],'k:');
            hold(self.ax,'on')
            set(self.ax,'XLim', [-P.Length,P.Length],'YLim',[-P.Length,P.Length],...
                'dataaspectratio',[1 1 1]);
            
            % Initialize Ball Beam and Draw
            self.beam = SLine([0,self.beam_l],[0,0],self.ax);
            self.ball = Circle(self.ball_r,[0; self.ball_r],50,self.ax);
        end
        % -----------------------
        function self = draw(self,x)
            z = x(1);
            theta = x(2);
            
            self.ball.translate([z*cos(theta); z*sin(theta)]);
            self.beam.rotate(theta*180/pi);
        end
        %-----------------------        
    end
    
end