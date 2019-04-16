classdef ReverbNode < Node       
    methods
        
        function obj = ReverbNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('wetdry', 0.5); %1
            obj.settings{end + 1} = obj.newSetting('delay', 1); %2
            obj.settings{end + 1} = obj.newSetting('delay', 0.4); %3
        end
                      
        function applyEffect(obj, buffer)
            global frameLength;
            global Fs;
            preDelay = obj.settings{1}.value;       
            wetDry = (obj.settings{2}.value/1000); %from ms to seconds
            diffusion = obj.settings{3}.value;
            
            reverb = reverberator('PreDelay', preDelay, 'WetDryMix', wetDry, 'Diffusion', diffusion, 'SampleRate', Fs);
            
            
            concBuffer = obj.contBuffer.concatBuffers(buffer); %Concatenate
            manipulatedBuffer = reverb(concBuffer); %apply
            wetBuffer = manipulatedBuffer(obj.contBuffer.totalBufferSize-frameLength+1:end); %Split
            obj.contBuffer.previousBuffer = obj.contBuffer.updatePreviousBuffer(buffer); %Update prev buffer
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end