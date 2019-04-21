classdef ReverbNode < Node
    
    methods
        
        function obj = ReverbNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('wetdry', 0.5); %1
            obj.settings{end + 1} = Setting('Diffusion', 0.5, 0, 1, 0.1, obj); %2
            obj.settings{end + 1} = Setting('Pre-delay', 0, 0, 1, 0.1, obj); %3
            obj.settings{end + 1} = Setting('Decay', 0.5, 0, 1, 0.1, obj); % 4
            
        end
                      
        function applyEffect(obj, buffer)
            global frameLength;
            global Fs;
            preDelay = obj.settings{3}.value;       
            wetDry = obj.settings{1}.value;
            diffusion = obj.settings{2}.value;
            decay = obj.settings{4}.value;
            
            reverb = reverberator('PreDelay', preDelay, 'WetDryMix', wetDry, 'Diffusion', diffusion, 'DecayFactor', decay, 'SampleRate', Fs);
                      
            %Continous buffer with an extra step of stereo to mono
            %conversion
            concBuffer = obj.contBuffer.concatBuffers(buffer); %Concatenate
            manipulatedBuffer = reverb(concBuffer); %The effect is returned as stereo instead of mono
            
            %Convert from stereo to mono
            mono = (manipulatedBuffer(:,1) + manipulatedBuffer(:,2)) / 2; %Add the 2 channels together, then divide by 2
            
            wetBuffer = mono(obj.contBuffer.totalBufferSize-frameLength+1:end); %Only take 1 channel, and then do the usual split
            obj.contBuffer.previousBuffer = obj.contBuffer.updatePreviousBuffer(buffer); %Update prev buffer
            
            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end