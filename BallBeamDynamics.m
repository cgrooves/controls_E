classdef BallBeamDynamics < handle
    
    properties
        state
        m1
        m2
        l
        g
        Ts
        var
        initials
    end
    
    methods
        % ---Constructor---
        function self = BallBeamDynamics(P)
            
            % initialize state vector
            self.state = [...
                P.z0;...
                P.zdot0;...
                P.theta0;...
                P.thetadot0;...
                ];
            self.initials = self.state; % store initial values
            
            % initialize other sim parameters
            % introduce up to 20% uncertainty in parameters
            self.var = P.var;
            
            self.m1 = P.m1*((2*self.var)*rand + (1-self.var));
            self.m2 = P.m2*((2*self.var)*rand + (1-self.var));
            self.l = P.l*((2*self.var)*rand + (1-self.var));
            
            self.g = P.g;
            self.Ts = P.Ts;
        end
        %---------------------
        function self = propagateDynamics(self,u)
            %
            % Integrate the differential equations defining dynamics by
            % using Runga-Kutta 4th order methods.
            % u is the system inpus (f)
            
            k1 = self.derivatives(self.state, u);
            k2 = self.derivatives(self.state + self.Ts/2*k1, u);
            k3 = self.derivatives(self.state + self.Ts/2*k2, u);
            k4 = self.derivatives(self.state + self.Ts*k3, u);
            self.state = self.state + self.Ts/6 * (k1 + 2*k2 + 2*k3 + k4);
            
%             if self.state(1) > self.l
%                 self.state(1) = self.l;
%                 self.state(2) = 0;
%             elseif self.state(1) < 0
%                 self.state(1) = 0;
%                 self.state(2) = 0;
%             end
        end
        %-----------------------
        function xdot = derivatives(self,state,u)
           
           % Return xdot = f(x,u) the derivatives of the continuous states
           % as a matrix
           f = u;
           
           xdot = zeros(4,1);
           xdot(1) = state(2);
           xdot(2) = state(1)*state(4)^2 - self.g*sin(state(3));
           xdot(3) = state(4);
           xdot(4) = 1/(self.m2*self.l^2/3 + self.m1*state(1)^2)*...
               ((f*self.l - self.m1*self.g*state(1) - self.m2*self.g*self.l/2)...
               *cos(state(3)) - 2*self.m1*state(1)*state(2)*state(4));
        end
        % ----------------------
        function y = output(self)
            % Return the generalized coord's
            y = [self.state(1); self.state(3)];
        end
        % ----------------------
        function self = reset(self)
            self.state = self.initials;
        end
        % ----------------------
    end
end