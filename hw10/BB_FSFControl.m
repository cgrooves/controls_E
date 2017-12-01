classdef BB_FSFControl < handle
    
    properties
        K
        ki
        L
        A
        B
        Cm
        
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
        
        x_hat
        u_d1
        
        error_d1
        errordot_d1
        ui
    end
    
    methods
        %----------------------------------
        function self = BB_FSFControl(P)
            self.K = P.K1; % gains
            self.ki = P.ki1;
            self.L = P.L;
            self.A = P.A;
            self.B = P.B;
            self.Cm = P.Cr;
                       
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
            
            self.x_hat = [0 0 0 0]';
            self.u_d1 = 0;
        end
        %----------------------------------
        function u = input(self,r,z,theta)
            self.updateObserver(z);
            z_hat = self.x_hat(1);
            
            % implement integrator
            error = r - z_hat;
            self.integrateError(error);
            
            u_tilde = -self.K*self.x_hat - self.ki*self.ui; % calculated input   
            u_eq = self.g*(self.m1*self.x_hat(1)/self.l + self.m2/2); % equilibrium force
            u_unsat = u_tilde + u_eq + 1; % unsaturated force
            u = self.saturate(u_unsat); % saturated force
            self.updateU(u);
            
            %integrator anti-windup
            if self.ki ~= 0
                self.ui = self.ui + (u-u_unsat)/self.ki;
            end            

            
        end
        %----------------------------------
        function self = updateObserver(self,z_m)
            % computer u_eq
            u_eq = self.g*(self.m1*self.x_hat(1)/self.l + self.m2/2); % equilibrium force
            
            N = 10;
            for i=1:N
                self.x_hat = self.x_hat + self.Ts/N*(...
                    self.A*self.x_hat + self.B*(self.u_d1-u_eq)...
                    + self.L*(z_m-self.Cm*self.x_hat));
            end           
        end
        %---------------------------------
        function self = integrateError(self,error)
            self.ui = self.ui + (self.Ts/2)*(error+self.error_d1);
            self.error_d1 = error;
        end
        %---------------------------------
        function self = updateU(self,u)
            self.u_d1 = u;
        end
        %---------------------------------
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