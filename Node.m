classdef Node
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        effect
        outputWaveForm
    end
    
    methods
        function obj = Node(effect)
            %Sets the effect of the node to be the given effect created
            obj.effect = effect;
        end
        
        function ApplyEffect(obj)
            %Applies the effect of the node to the waveform
            obj.effect.apply();
        end
    end
end

