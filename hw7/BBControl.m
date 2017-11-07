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
           
           self.thetaCtrl = PDControl(P.theta_gains.kP,P.theta_gains.kD,P.tau,P.Ts,P.sat_limit);
           self.zCtrl = PIDControl(P.z_gains,P.tau,P.Ts,P.sat_limit,0.1);
           
           self.m1 = P.m1;
           self.m2 = P.m2;
           self.l = P.l;
           self.g = P.g;
           
           self.limit = P.sat_limit;
           
       end
       %----------------
       function force = u(self,z_r,z,theta)
           % Get equilibrium force for current position
           F_eq = self.g*(self.m1*z/self.l + self.m2/2); % equilibrium force

           % Get theta_ref from zCtrl
           theta_ref = self.zCtrl.PID(z_r,z,0.0,0);
           
           % Get force from theta_ref
           force = self.thetaCtrl.PD(theta_ref,theta,F_eq);
           
           
       end
       %----------------
        
    end
    
end