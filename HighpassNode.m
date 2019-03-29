classdef HighpassNode < Node  
    
    properties
        cutoffHz = 200;
    end
    methods
           
        function obj = HighpassNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('cutoff', 0.5); %1

        end
        
        function applyEffect(obj, buffer)
            global Fs;
            wetBuffer = highpass(buffer, obj.cutoffHz, Fs);            
            
            obj.passToNextNode(wetBuffer);
            
            
        end
    end
end