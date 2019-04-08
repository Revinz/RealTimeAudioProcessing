classdef DelayNode < Node 
    
    properties
        %Used to prevent popcorn sound, by also manipulating the previous buffer
        prevBuffer = [];
    end
    methods
        
        function obj = DelayNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('wetdry', 0.5); %1
            obj.settings{end + 1} = obj.newSetting('noteDelay', 1); %2
            obj.settings{end + 1} = obj.newSetting('bpm', 120); %3
            obj.settings{end + 1} = obj.newSetting('feedback', 0.5); %4
        end
                      
        function applyEffect(obj, buffer)
            global Fs;
            global frameLength;
            bps = obj.settings{3}.value/60;
            secperbeat = 1/bps;
            noteDiv = obj.settings{2}.value;
            timeSec = noteDiv * secperbeat;
            delay = fix(timeSec*Fs);
            feedback = obj.settings{4}.value;
            
            %Concatenate the two buffers to perform the audio manipulation
            concatBuffer = obj.contBuffer.concatBuffers(buffer);
            for n = 1:length(concatBuffer)
                if n < delay+1
                    delayedBuffer(n,1) = concatBuffer(n,1);
                else
                    delayedBuffer(n,1) = concatBuffer(n,1) + feedback*concatBuffer(n-delay,1);
                end
            end

            %Split it in half to keep the buffer size the same as the input
            %buffer
            mix = obj.settings{1}.value;
            finalDelayedBuffer = delayedBuffer(obj.contBuffer.totalBufferSize-frameLength+1:end);
            wetBuffer = finalDelayedBuffer;% * mix + buffer * (1-mix);
            
            %Update the previous buffer
            disp(length(obj.contBuffer.previousBuffer))
            obj.contBuffer.previousBuffer = obj.contBuffer.updatePreviousBuffer(buffer);

            obj.passToNextNode(wetBuffer);
            
        end
    end
end