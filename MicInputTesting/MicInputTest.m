
frameLength = 12288;
Fs = 48000;


inputDevice = audioDeviceReader(Fs, frameLength,'BitDepth','16-bit integer');
outputDevice = audioDeviceWriter( ...
    'SampleRate',inputDevice.SampleRate); 

reverb = reverberator( ...                  
    'SampleRate',inputDevice.SampleRate, ... 
    'PreDelay',0.5, ...                       
    'WetDryMix',0.4);                       

%Graph
scope = dsp.TimeScope( ...        
'SampleRate',inputDevice.SampleRate, ... 
'TimeSpan',0.05, ...                      
'BufferLength',1.5e6, ...               
'YLimits',[-0.3,0.3]);  

%Listen to audio and playback in real-time
bufferLatency = inputDevice.SamplesPerFrame/outputDevice.SampleRate
totalUnderrun = 0;
signal = inputDevice(); 
while true                  
    signal = inputDevice(); 
    
    %Audio manipulation
    flangerSignal = Flangerinput(signal, Fs, 1);
    reverbSignal = reverb(signal);
    
    %Output and graph
    outputDevice(flangerSignal);
    scope([flangerSignal,signal]); 
end                                         

release(inputDevice)                         
release(outputDevice) 
release(scope)


function flanger = Flangerinput(Input, Fs, wetdry_ratio)
    
    delay = 24;
    range = 12;
    sweep_freq = 0.4;
    flanger = zeros(size(Input));

        
%     %Faster computation of flanger
    sample = 1:1:length(Input)-delay-range;
    flanger(sample) = Input(sample) + Input(sample+delay+round(range*sin(2*pi*sample*sweep_freq/Fs)));
        
    
%      for i = 1:length(Input)-delay-range
%            flanger(i) = Input(i) + Input(i+delay+round(range*sin(2*pi*i*sweep_freq/Fs)));   
%      end
     
     
     %output = flanger * wetdry_ratio + Input * (1-wetdry_ratio);
     
    return % Returns 'flanger' (see 'flanger = Flanger(...) )
end



