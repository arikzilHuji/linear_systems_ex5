function [ampSpec, f_half, f, Y, modes, figs] = mySpectrum(x, Fs, plotFlag, plotTitle, saveFigFlag) 
%
% Calculate the Fourier amplitude spectrum of the signal x
%
% inputs
% ------
%   x           - a signal (assumed to consist of real numbers)
%   Fs          - sampling frequency of x
%   plotFlag    - true/false flag, whether to generate plots
%   saveFigFlag - true/false flag, whether to save fig to png
%
% outputs
% -------
%   ampSpec - the ampliude spectrum of x
%   f_half  - the frequency vector corresponding to ampSpec
%   f       - the full frequencies vector (in Hz) corresponding to Y
%             (including "negative" frequenciee)
%   Y       - the result of fft(X)
%   modes   - the number of mode (n) corresponding to each entry of Y
%             (including "negative" modes)
%   figs    - a vector of figure handles generates if required
%
% (c) Tsevi Beatus, HUJI.
%
if ~exist('plotFlag','var')
    plotFlag = true ;
end

if ~exist('saveFigFlag','var')
    saveFigFlag = false ;
end

if ~exist('plotTitle','var')
    plotTitle = 'Signal' ;
else
    plotTitle = string(plotTitle) ;
end


N      = length(x) ;
modes  = 0:N-1 ;
% find number of the highest mode (account for odd/even N)
N_fastest = ceil((N+1)/2) ;  

% set mode number of negative modes (account for odd/even N)
modes(N_fastest+1 : end) = modes(N_fastest+1 : end) - N ;
f = modes * Fs / N ;  % full frequency vector

% frequencies corresponding to spectrum (i.e. to modes with n>=0)
f_half = f(1:N_fastest) ; 

Y = fft(x); % at last, perform the Fourier Transform

P2 = abs(Y/N) ;  % calc amplitude of entire Y and normalize by 1/N
                % to get acctual amplitude spectrum
                
% take the n>=0 half of the spectrum, corresponding to "positive" frequencies
% most modes appear twice (once positive, once negative). This is taken
% care of below.
ampSpec = P2(1:N_fastest); 

d = (mod(N,2)==0) ;  % d is either 1 or 0.
ampSpec(2:end-d) = sqrt(2)*ampSpec(2:end-d);
% explanation for the above two lines:
% multiply by 2 only those modes that appear twice in fft
% either way, do not multiply the first term x2.
% the last term depends whether N is odd/even
% the above two lines can handle both odd and even N 
% if N is ODD we get d=1, then we do not x2 last term
% if N is EVEN we get d=0, then we x2 all terms


%{
% the above lines are equivalent to
if mod(N,2)==0
    ampSpec(2:end-1) = 2*ampSpec(2:end-1); % for even N 
else
    ampSpec(2:end) = 2*ampSpec(2:end);     % for odd N 
end
%}

% all is left to do is to plot stuff
if plotFlag
    
    ind = 1:N_fastest;
    t_vec = (0:N-1) / Fs ; % time vector
    
    % plot fft output
    h1 = figure('color','w','position',[200 100 1000 600]) ;
    subplot(2,2,1) ; plot(real(Y),'b-') ; set(gca,'fontsize',14) ;
    xlabel('index') ; ylabel('Real part') ; title([char(plotTitle) ' - FFT output vs. index']) ;
    ylim([-200,200]) ;
    subplot(2,2,3) ; plot(imag(Y),'r-') ; set(gca,'fontsize',14) ;
    xlabel('index') ; ylabel('Imaginary part') ; title([char(plotTitle) ' - FFT output vs. index']) ;
    subplot(2,2,2) ; plot(f_half, real(Y(ind)),'b-') ; set(gca,'fontsize',14) ;
    xlabel('Frequency [Hz]') ; ylabel('Real part') ; title('FFT output vs. f') ;
    subplot(2,2,4) ; plot(f_half, imag(Y(ind)),'r-') ; set(gca,'fontsize',14) ;
    xlabel('Frequency [Hz]') ; ylabel('Imagnary part') ; title('FFT output vs. f') ;
    set(findall(gcf,'-property','FontSize'),'FontSize',14) ;
    set(findall(gcf,'-property','Interpreter'),'Interpreter','latex') ;
    set(findall(gcf,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex') ;
    
    if saveFigFlag
        print(gcf,'Fig_2_Raw_FFT','-dpng','-r0') ;
    end
    

    cols = lines(2) ;
    h2 = figure('color','w','position',[600 100  500 600]) ; 
    subplot(2,1,1) ; plot(t_vec, x,'color',cols(1,:)) ; set(gca,'fontsize',14) ;
    xlim([t_vec(1), t_vec(end)]) ;
    xlabel('Time [sec]'); ylabel('Signal') ; title(plotTitle) ;
    box on ; grid on ;
    subplot(2,1,2) ; plot(f_half, ampSpec,'color',cols(2,:)) ; set(gca,'fontsize',14) ;
    xlim([f_half(1), f_half(end)]) ;
    xlabel('f [Hz]'); ylabel('Amplitude') ; title('Amplitude spectrum') ;
    box on ; grid on ;
    set(findall(gcf,'-property','FontSize'),'FontSize',14) ;
    set(findall(gcf,'-property','Interpreter'),'Interpreter','latex') ;
    set(findall(gcf,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex') ;
    if saveFigFlag
        print(gcf,'Fig_2_Signal_and_Amplitude_Spectrum','-dpng','-r0') ;
    end  
    
    %{
    % plot amplitude-spectrum only 
    h3 = figure('color','w','position',[500 100  500 400]) ; hold on ;
    plot(f_half, ampSpec) ; set(gca,'fontsize',14) ;
    xlabel('f [Hz]'); ylabel('Amplitude') ; title('Amplitude spectrum') ;
    box on ; grid on ;
    if saveFigFlag
        print(gcf,'Fig_1_Amplitude_Spectrum','-dpng','-r0') ;
    end
    %}
    figs = [h1, h2] ;
else
    figs = [] ;
end

return

