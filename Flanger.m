classdef Flanger < Effect
    % Flanger effect
    % Works by delaying the sound by x ms, and by varying
    % this delay over time.
    
    properties
        delayMS = 0.2 % Initial delay of the audio
        rateHz = 0.25 %In radians. For the oscilliation of the delay
        depth = 30% Peak amplitude of the oscillation
        feedback = 0.4 % Currently unsure of how the feedback works
    end
    
    methods    
        function Apply(obj)
            %Applies the flanger effect to the waveform
            
            
            
        end
    end
end

