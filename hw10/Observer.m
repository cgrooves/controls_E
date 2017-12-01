classdef Observer < handle
    % returns Observer gains based on desired poles
    
    properties
        A
        B
        Cm
        Obs
        
    end
    
    methods
        %---------------------------------------
        function self = Observer(A,B,Cm)
            
            % set state matrices
            self.A = A;
            self.B = B;
            self.Cm = Cm;
            
            self.Obs = self.observability();
            
        end
        %---------------------------------------
        function O = observability(self)
            
            n = size(self.Cm,2);
            O = zeros(n);
            
            for i = 0:n-1
                O(i+1,:) = self.Cm*(self.A^i);
            end
            
            if det(O) == 0
                disp('System is not observable');
            else
                disp('System is observable');
            end
            
        end
        %---------------------------------------
        function L = gains(self,desired_poles)
            
            L = place(self.A',self.Cm',desired_poles)';
            
        end
        %---------------------------------------
        
    end
    
end