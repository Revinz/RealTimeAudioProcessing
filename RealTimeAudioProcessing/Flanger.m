classdef (StrictDefaults)Flanger < matlab.System & matlab.system.mixin.Propagates
%Flanger Add flanging effect to audio signal.
%
%   FLANGER = audioexample.Flanger returns an flanger System object,
%   FLANGER, that adds flanging effect to the audio signal.
%
%   FLANGER = audioexample.Flanger('Name', Value, ...) returns a flanger
%   System object, FLANGER, with each specified property name set to the
%   specified value. You can specify additional name-value pair arguments
%   in any order as (Name1,Value1,...,NameN, ValueN).
%
%   Step method syntax:
%      
%   Y = step(FLANGER, X) adds flanging effect for the audio input X based
%   on the properties specified in the object FLANGER and returns it as
%   audio output Y. Each column of X is treated as individual channel of
%   input.
%
%   System objects may be called directly like a function instead of using
%   the step method. For example, y = step(obj, x) and y = obj(x) are
%   equivalent.
%
%   Flanger methods:
%
%   step     - See above for the description of the method
%   reset    - Resets the internal state to initial conditions
%   clone    - Create Flanger system object with similar property values
%   isLocked - Locked status (logical)
%   
%   Flanger properties:
%   
%   Delay         - Base delay in seconds
%   Depth         - Amplitude of modulator
%   Rate          - Frequency of modulator
%   FeedbackLevel - Feedback gain
%   WetDryMix     - Wet to dry signal ratio
%   SampleRate    - Sample rate of the input audio signal   
%
%   % Example: Add chorus effect to an audio signal.
%
%   reader = dsp.AudioFileReader('SamplesPerFrame', 1024,...
%     'PlayCount', 3);
% 
%   player = audioDeviceWriter('SampleRate', reader.SampleRate);
% 
%   flanger = audioexample.Flanger;
% 
%   while ~isDone(reader)
%       Input = reader();
%       Output = flanger(Input);
%       player(Output);
%   end
% 
%   release(reader)
%   release(player)

% Copyright 2015-2016 The MathWorks, Inc.
%#codegen
    
    %----------------------------------------------------------------------
    %   Public, tunable properties.
    %----------------------------------------------------------------------
    properties %Some value maxs have been changed
        %Delay Base delay
        %   Specify the base delay for flanger effect as positive scalar
        %   value in seconds. Base delay value must be in the range between
        %   0 and 0.1 seconds. The default value of this property is
        %   0.001.
        Delay = 0.001
        
        %Depth Amplitude of modulator
        %   Specify the amplitude of modulating sine wave as a positive
        %   scalar value. This sinewave is added to the base delay value to
        %   make the delay sinusoidally modulating. The value must range
        %   from 0 to 50. The default value of this property is 30.
        Depth = 30
        
        %Rate Frequency of modulator
        %   Specify the frequency of the sine wave as a positive scalar
        %   value in Hz. This property controls the flanging rate. The
        %   value must range from 0 to 0.5 Hz. The default value of this
        %   property is 0.25.
        Rate = 0.25
        
        %FeedbackLevel Feedback gain value.
        %   Specify the feedback gain value as a positive scalar. This
        %   value must range from 0 to 1. Setting FeedbackLevel to 0 turns
        %   off the feedback path. The default value of this property is
        %   0.4.
        FeedbackLevel = 0.4
        
        %WetDryMix Wet/dry mix
        %   Specify the wet/dry mix ratio as a positive scalar. This value
        %   ranges from 0 to 1. For example, for a value of 0.6, the ratio
        %   will be 60% wet to 40% dry signal (Wet - Signal that has effect
        %   in it. Dry - Unaffected signal). The default value of this
        %   property is 0.5.
        WetDryMix = 0.5
    end
    %----------------------------------------------------------------------
    %   Non-tunable properties.
    %----------------------------------------------------------------------
    properties (Nontunable)
        %SampleRate Sampling rate of input audio signal
        %   Specify the sampling rate of the audio signal as a positive
        %   scalar value.  The default value of this property is 44100 Hz.
        SampleRate = 44100
    end
    %----------------------------------------------------------------------
    %   Private, non-tunable properties.
    %----------------------------------------------------------------------
    properties (Access = private, Nontunable)
        %pDataType is the data type of input signal. To maintain similar
        %   data type throughout the process, this property is used to type
        %   cast the variables.
        pDataType
    end
    %----------------------------------------------------------------------
    %   Private properties.
    %----------------------------------------------------------------------
    properties (Access = private)
        %pDelayInSamples is the number of samples required to delay the
        %   input signal.
        pDelayInSamples 
        
        %pDelay is the object for fractional delay with linear
        %interpolation and feedback.
        pDelay
        
        %pSineWave is the oscillator for generating sine wave.
        pSineWave

        %pWetDryMix WetDryMix casted to input data type
        pWetDryMix
    end
    %----------------------------------------------------------------------
    %   Public properties.
    %----------------------------------------------------------------------
    methods
        % Constructor for Flanger system object.
        function obj = Flanger(varargin)
            
            % Set properties according to name-value pairs
            setProperties(obj,nargin,varargin{:});
        end
        %------------------------------------------------------------------
        % These set functions validate the attributes and limits of the
        % properties of this system object.
        function set.Delay(obj,Delay)
            validateattributes(Delay,{'numeric'},{'scalar','real','>=',0,'<=',0.1},'Flanger','Delay');
            obj.Delay = Delay;
        end
        
        function set.Depth(obj,Depth)
            validateattributes(Depth,{'numeric'},{'scalar','real','>=',0,'<=',80},'Flanger','Depth');
            obj.Depth = Depth;
        end
        
        function set.Rate(obj,Rate)
            validateattributes(Rate,{'numeric'},{'scalar','real','>=',0,'<=',1},'Flanger','Rate');
            obj.Rate = Rate;
        end
        
        function set.WetDryMix(obj,WetDryMix)
            validateattributes(WetDryMix,{'numeric'},{'scalar','real','>=',0,'<=',1},'Flanger','WetDryMix');
            obj.WetDryMix = WetDryMix;
        end
        
        function set.FeedbackLevel(obj,FeedbackLevel)
            validateattributes(FeedbackLevel,{'numeric'},{'scalar','real','>=',0,'<=',1},'Flanger','FeedbackLevel');
            obj.FeedbackLevel = FeedbackLevel;
        end
        
        function set.SampleRate(obj,SampleRate)
            validateattributes(SampleRate,{'numeric'},{'scalar','real','>',0},'Flanger','SampleRate');
            obj.SampleRate = SampleRate;
        end
    end
    %----------------------------------------------------------------------
    %   Protected methods
    %----------------------------------------------------------------------
    methods (Access = protected)
        function setupImpl(obj,Input)
            obj.pDataType = class(Input);
            
            % Create the tunable sine wave oscillator
            obj.pSineWave = audioOscillator('Frequency',obj.Rate,...
                'Amplitude',obj.Depth,...
                'SampleRate',obj.SampleRate, ...
                'OutputDataType', obj.pDataType);
            
            % Create the fractional delay object
            obj.pDelay = audioexample.DelayFilter(...
                'SampleRate',obj.SampleRate,...
                'FeedbackLevel',obj.FeedbackLevel);
            
            % Set the tunable properties
            processTunedPropertiesImpl(obj)
            
            % Setup the oscillator and DelayFilter object
            setup(obj.pSineWave);
            setup(obj.pDelay,obj.pDelayInSamples,Input)
        end
        %------------------------------------------------------------------
        function resetImpl(obj)
            % Reset the delay and sine wave objects
            reset(obj.pDelay)
            reset(obj.pSineWave)
        end
        %------------------------------------------------------------------
        function Output = stepImpl(obj,Input)
            % Create the delay vector. Delay in samples are added to the
            % sine wave here.
            obj.pSineWave.SamplesPerFrame = size(Input, 1);
            DelayVector = obj.pDelayInSamples + obj.pSineWave();
            
            % Calculate delayed output
            Output = obj.pDelay(DelayVector,Input);
            
            % Calculate output by adding wet and dry signal in appropriate
            % ratio.
            mix = obj.pWetDryMix;
            Output = (1-mix)*Input + (mix)*Output;
        end
        %------------------------------------------------------------------
        % When tunable property changes, this function will be called.
        function processTunedPropertiesImpl(obj)
            % When Delay property changes, we have recalculate
            % pDelayInSamples property. Note that to maintain similar data
            % types throughout the process, cast function is used.
            obj.pDelayInSamples = cast(obj.Delay*obj.SampleRate, obj.pDataType);
            
            % Set the amplitude of sine wave object when Depth property
            % changes.
            obj.pSineWave.Amplitude = obj.Depth;
            
            % Set the frequency of sine wave when Rate property changes.
            obj.pSineWave.Frequency = obj.Rate;
            
            % Setting feedback level of delay object when FeedbackLevel
            % property changes.
            obj.pDelay.FeedbackLevel = obj.FeedbackLevel;

            % Cast obj.WetDryMix to correct data type
            obj.pWetDryMix = cast(obj.WetDryMix, obj.pDataType);
        end
        %------------------------------------------------------------------
        function validateInputsImpl(~,Input)
            % Validate inputs to the step method at initialization.
            validateattributes(Input,{'single','double'},{'nonempty'},'Flanger','Input');            
        end
        %------------------------------------------------------------------
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                s.pDelay = matlab.System.saveObject(obj.pDelay);
                s.pSineWave = matlab.System.saveObject(obj.pSineWave);
                s.pDelayInSamples = obj.pDelayInSamples;
                s.pWetDryMix = obj.pWetDryMix;
                s.pDataType = obj.pDataType;
            end
        end
        %------------------------------------------------------------------
        function loadObjectImpl(obj,s,wasLocked)
            if wasLocked
                obj.pDelay = matlab.System.loadObject(s.pDelay);
                obj.pSineWave = matlab.System.loadObject(s.pSineWave);
                obj.pDelayInSamples = s.pDelayInSamples;
                obj.pWetDryMix = s.pWetDryMix;
                obj.pDataType = s.pDataType;
            end
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        %------------------------------------------------------------------
        function releaseImpl(obj)
            release(obj.pDelay)
            release(obj.pSineWave)
        end
        %------------------------------------------------------------------
        % Propagators for MATLAB System block
        function flag = IsOutputComplexImpl(~)
            flag = false;
        end
        
        function flag = getOutputSizeImpl(obj)
            flag = propagatedInputSize(obj, 1);
        end
        
        function flag = getOutputDataTypeImpl(obj)
            flag = propagatedInputDataType(obj, 1);
        end
        
        function flag = isOutputFixedSizeImpl(obj)
            flag = propagatedInputFixedSize(obj,1);
        end
    end
end