function [f, X, t, x] = create_noise_from_spectrum(f_half, amp_spec)
%f_half – vector of “positive” frequencies
%amp_spec – absolute value of the spectrum in f_half
%------
%f, X – the entire frequencies vector and the Fourier transform of the noise respectively
%t, x – time vector and the signal in the time domain (noise), respectively

% part (a) find input length and define output length
n=length(f_half);
N=2*n-1;

%part (b) define the full frequncy vector
f=zeros(1,N);

% populate the vector in the follwing order:
% ,....,f_fastest,-f_fastest,....,-f_lowest
f=[f_half,flip((-1).*f_half(2:end))];

%part (c) define the full spectrum X
rand_phase = (2*pi).*rand(1, n-1);
left_half=exp(1i*rand_phase).*(amp_spec(2:end));
right_half=exp(-1i*rand_phase).*(amp_spec(2:end));
X=[amp_spec(1),left_half,flip(right_half)];

%part (d) define the time vector
f_fast=f_half(end);
dt=(N-1)/(2*N*f_fast);
t=zeros(1,N);

for i = 1:1:N
    t(i)= (i-1)*dt;
end    


%part (e) create the noise from the fourier coefficients
x=ifft(X);
