classdef FlangerNode < Node       
    methods
        
        function obj = FlangerNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('wetdry', 0.5); %1
            obj.settings{end + 1} = obj.newSetting('delay', 1); %2
            obj.settings{end + 1} = obj.newSetting('feedback', 0.4); %3
            obj.settings{end + 1} = obj.newSetting('depth', 30); %4
            obj.settings{end + 1} = obj.newSetting('rate', 0.25); %5
        end
                      
        function applyEffect(obj, buffer)
            flanger = Flanger();
            flanger.WetDryMix = obj.settings{1}.value;       
            flanger.Delay = (obj.settings{2}.value/1000); %from ms to seconds
            flanger.FeedbackLevel = obj.settings{3}.value;
            flanger.Depth = obj.settings{4}.value;
            flanger.Rate = obj.settings{5}.value;
            disp(flanger);
            wetBuffer = flanger(buffer);
            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end