%{
Excersice 5 matlab part
%}

%% --------------------------------------------------------------
%{
Question 2 
%}

% (4)
% vector t betweeen -1 and 1:
t = -1:0.001:1 ;

% x(t)
x=t.^2;

% frequency
Fs=1000;

% use myspacetrun function that was provided
[ampSpec, f_half, f, Y, modes, figs] = mySpectrum(x, Fs, false, "flage", false);

% calulcate the energy using the coefficet of fourier in the power of 2
Energy=ampSpec.^2;

% calulcate the total energy for all the spectrum
EneryTotal=cumsum(Energy);

% display the total energy in dependence of the frequency()
% Note!! that the file:"freq_amp_answ.jpg" disaplys the frequecny in the x-axis
% that the enery is above 90% as was requested.
figure();
plot( f_half , EneryTotal);
%% --------------------------------------------------------------
%{
Question 3
%}




