classdef BB_FSFControl < handle
    
    properties
        K
        ki
        
        beta
        Ts
        limit
        
        g
        m1
        l
        m2
        ze
        
        zdot_d1
        z_d1
        thetadot_d1
        theta_d1
        
        error_d1
        errordot_d1
        ui
    end
    
    methods
        %----------------------------------
        function self = BB_FSFControl(P)
            self.K = P.K1; % gains
            self.ki = P.ki1;
            
            self.beta = (2*P.tau - P.Ts)/(2*P.tau + P.Ts); % dirty derivative gain
            self.Ts = P.Ts;
            self.limit = P.sat_limit;
            
            self.g = P.g;
            self.m2 = P.m2;
            self.m1 = P.m1;
            self.l = P.l;
            self.ze = P.ze;
            
            % tracked values
            self.z_d1 = 0;
            self.zdot_d1 = 0;
            self.theta_d1 = 0;
            self.thetadot_d1 = 0;
            
            self.error_d1 = 0;
            self.errordot_d1 = 0;
            self.ui = 0;
        end
        %----------------------------------
        function u = input(self,r,z,theta)
            
            x = zeros(4,1);
            x(1) = z;
            x(3) = self.beta*self.zdot_d1 + 1/self.Ts*(1-self.beta)*(z - self.z_d1);
            x(2) = theta;
            x(4) = self.beta*self.thetadot_d1 + 1/self.Ts*(1-self.beta)*(theta - self.theta_d1);
            
            % implement integrator
            error = r - z;
            error_dot = self.beta*self.errordot_d1 + 1/self.Ts*(1-self.beta)*(error - self.error_d1);
%             if error_dot < .1
%                 self.ui = self.ui + (self.Ts/2)*(error + self.error_d1);
%             end
            self.ui = self.ui + (self.Ts/2)*(error + self.error_d1);
            
            u_tilde = -self.K*x - self.ki*self.ui; % calculated input   
            u_eq = self.g*(self.m1*x(1)/self.l + self.m2/2); % equilibrium force
            u_unsat = u_tilde + u_eq + 1; % unsaturated force
            u = self.saturate(u_unsat); % saturated force
            
            %integrator anti-windup
            if self.ki ~= 0
                self.ui = self.ui + (u-u_unsat)/self.ki;
            end            
            
                        
            % set old values to current ones
            self.z_d1 = x(1);
            self.zdot_d1 = x(3);
            self.theta_d1 = x(2);
            self.thetadot_d1 = x(4);
            
            self.error_d1 = error;
            self.errordot_d1 = error_dot;
            
        end
        %----------------------------------   
        function u = saturate(self,uin)
            
            if uin < self.limit(1)
                u = self.limit(1);
            elseif uin > self.limit(2)
                u = self.limit(2);
            else
                u = uin;
            end
            
        end
        %----------------------------------
    end  
end