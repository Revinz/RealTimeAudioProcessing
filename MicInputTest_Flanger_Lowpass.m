
frameLength = 1024 * 12;
Fs = 44100;


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
'YLimits',[-0.1,0.1]);  

%Listen to audio and playback in real-time
bufferLatency = inputDevice.SamplesPerFrame/outputDevice.SampleRate;
totalUnderrun = 0;
signal = inputDevice(); 


%First order low pass - NOT USED
% Ts = 1/Fs;
% timeVector = (0:Ts:length(signal)*Ts - Ts);
% filtnum = 2*pi*filtHz;
% filtden = [1 1*pi*filtHz];
% [filtnumd, filtdend] = c2dm(filtnum, filtden, Ts, 'zoh');
%signalFiltered = filter(filtnumd, filtdend, signal);

%filter frequency
filtHz = 300;


while true
    profile on
    signal = inputDevice(); 
    
    % real time manipulation
%     tus = get(gcf,'currentkey');
%     if (strcmp(tus,'space')) && filtHz > 100
%         filtHz = filtHz - 100
%     end
%     if (strcmp(tus,'return')) 
%         filtHz = filtHz + 100
%     end


    %signalFiltered = lowpass(signal,filtHz, Fs);
    %signalFiltered = highpass(signal,filtHz*4, Fs);
    
    %Audio manipulation
    signalFiltered = Flangerinput(signal, Fs, 1);
    %reverbSignal = reverb(signal);
    
    %Output and graph frameLength)
    outruns = outputDevice(signalFiltered)
    profile viewer
    scope([signalFiltered]); 
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



