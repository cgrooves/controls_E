classdef BBControl
   
    properties
        thetaCtrl
        zCtrl
        
        m1
        m2
        l
        g
        
        limit
        
    end
    
    methods
       %----------------
       function self = BBControl(P)
           self.thetaCtrl = PDControl(P.kp_theta,P.kd_theta,P.Ts);
           self.zCtrl = PDControl(P.kp_z,P.kd_z,P.Ts,P.sat_limit);
           
           self.m1 = P.m1;
           self.m2 = P.m2;
           self.l = P.l;
           self.g = P.g;
           
           self.limit = P.sat_limit;
           
       end
       %----------------
       function force = u(self,z_r,z,theta)
           
           % Get theta_ref from zCtrl
           theta_ref = self.zCtrl.PD(z_r,z);
           
           % Get force from theta_ref
           F_eq = self.g*(self.m1*z/self.l + self.m2/2); % equilibrium force
           init_force = self.thetaCtrl.PD(theta_ref,theta) + F_eq;
           
           % saturation block
           if init_force < self.limit(1)
               force = self.limit(1);
           elseif init_force > self.limit(2)
               force = self.limit(2);
           else
               force = init_force;
           end
           
       end
       %----------------
        
    end
    
end