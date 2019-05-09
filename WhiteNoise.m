
lowest_freq = 0;
high_freq = 100000;
f_fast = high_freq;
N = 1000001;
dt = 2*high_freq/N;
disp(dt)
f_half = lowest_freq:dt:high_freq; 



%Part 2
spec = f_half.*0;
find_first_place = find(f_half >= 20 & f_half <= 20000);
spec(find_first_place) = 15;

% create the noise 
[f, X, t, x] = create_noise_from_spectrum(f_half,spec);

% calculate the frequncy
Fs=N/5
sound(x,Fs)