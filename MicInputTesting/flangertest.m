[x,Fs] = audioread('wouldntmind.wav');


N = length(x);
y = zeros(N,1);

x = x(:,1);
delay = 15;
range = 12;
sweep_freq = 0.4;
for i = 1:length(x)-delay-range
     y(i) = x(i) + x(i+delay+round(range*sin(2*pi*i*sweep_freq/Fs)));
    
     
end

sound(y,Fs)
pause(5)
clear sound;