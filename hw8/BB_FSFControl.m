classdef BB_FSFControl < handle
    
    properties
        kr
        K
        
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
    end
    
    methods
        %----------------------------------
        function self = BB_FSFControl(P)
            self.kr = P.kr; % feedforward gain
            self.K = P.K; % gains
            
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
        end
        %----------------------------------
        function u = input(self,r,z,theta)
            
            x = zeros(4,1);
            x(1) = z;
            x(3) = self.beta*self.zdot_d1 + 1/self.Ts*(1-self.beta)*(z - self.z_d1);
            x(2) = theta;
            x(4) = self.beta*self.thetadot_d1 + 1/self.Ts*(1-self.beta)*(theta - self.theta_d1);
            
            u_tilde = self.kr*r - self.K*x; % calculated input   
            u_eq = self.g*(self.m1*x(1)/self.l + self.m2/2); % equilibrium force
            u = self.saturate(u_tilde + u_eq); % total force, saturated
                        
            % set old values to current ones
            self.z_d1 = x(1);
            self.zdot_d1 = x(3);
            self.theta_d1 = x(2);
            self.thetadot_d1 = x(4);
            
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