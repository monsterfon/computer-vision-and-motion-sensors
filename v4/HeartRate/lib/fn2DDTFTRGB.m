function [A, AW, f] = fn2DDTFTRGB(x, GV, plotTitle)

L         = length(x); 
n         = 0:L-1;
%% dtft
omega     = linspace(GV.omDTFTMin,GV.omDTFTMax,GV.DTFTNumOfPoints);
% omega     = linspace(GV.fDTFTMin/GV.fsDeafult*2*pi,GV.fDTFTMax/GV.fsDeafult*2*pi,GV.fNumOfPoints);
f         = omega/2/pi*GV.fsDeafult*60;
[A] = fnDTFT(x, omega); 
AX2D = fft(A); Aak = ifft(AX2D.*conj(AX2D));
Aak(:,1) = Aak(:,1).*sqrt([f(1:GV.fNumOfPoints/2)'; f(GV.fNumOfPoints/2:-1:1)']); 
Aak(:,2) = Aak(:,2).*sqrt([f(1:GV.fNumOfPoints/2)'; f(GV.fNumOfPoints/2:-1:1)']);
Aak(:,3) = Aak(:,3).*sqrt([f(1:GV.fNumOfPoints/2)'; f(GV.fNumOfPoints/2:-1:1)']);
%% windowing
if GV.bitWin
    w          = hamming(L); 
    W          = w*ones(1,size(x,2));
    xw         = x.*W;
    [~,AW,~,~] = fnDTFT(xw, omega); 
    AWX2D = fft(AW); AWak = ifft(AWX2D.*conj(AWX2D));
    AWak(:,1) = AWak(:,1).*sqrt([f(1:GV.fNumOfPoints/2)'; f(GV.fNumOfPoints/2:-1:1)']); 
    AWak(:,2) = AWak(:,2).*sqrt([f(1:GV.fNumOfPoints/2)'; f(GV.fNumOfPoints/2:-1:1)']);
    AWak(:,3) = AWak(:,3).*sqrt([f(1:GV.fNumOfPoints/2)'; f(GV.fNumOfPoints/2:-1:1)']);

else
    xw         = x;
    AW         = A;
end

if GV.DebugInterPlot
    figure; sgtitle(plotTitle)
    %% time plot
    %% original
    subplot(321), hold on
    for i = 1:size(x,2)
        plot(n,x(:,i),GV.plotColors(i,:))
    end
    xlabel('$n$', 'Interpreter', 'latex'), ylabel('$x[n]$', 'Interpreter', 'latex')
    axis([min(n) max(n) min(min(x)) max(max(x))])
    %% windowed
    subplot(322), hold on
    for i = 1:size(xw,2)
        plot(n,xw(:,i),GV.plotColors(i,:))
    end
    xlabel('$n$', 'Interpreter', 'latex'), ylabel('$x_w[n]$', 'Interpreter', 'latex')
    axis([min(n) max(n) min(min(xw)) max(max(xw))])
    
    %% frequency plot
    %% original
    subplot(323), hold on
    for i = 1:size(x,2)
        plot(f/60,A(:,i),GV.plotColors(i,:))
    end
    plot(f/60,(A(:,2)-A(:,3)),'k', 'LineWidth', 1.1)
    xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_X (f)$', 'Interpreter', 'latex')
    axis([min(f/60) max(f/60) min(min(A)) max(max(A))])
    %% windowed
    subplot(324), hold on
    for i = 1:size(x,2)
        plot(f/60,AW(:,i),GV.plotColors(i,:))
    end
    plot(f/60,(AW(:,2)-AW(:,3)),'k', 'LineWidth', 1.1)
    xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_{XW} (f)$', 'Interpreter', 'latex')
    axis([min(f/60) max(f/60) min(min(AW)) max(max(AW))])  
    
    %% frequency plot
    %% original
    subplot(325), hold on
    for i = 1:size(x,2)
        plot(f/60,Aak(:,i),GV.plotColors(i,:))
    end
    xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_X (f)$', 'Interpreter', 'latex')
    axis([min(f/60) max(f/60) min(min(Aak)) max(max(Aak))])
    %% windowed
    subplot(326), hold on
    for i = 1:size(x,2)
        plot(f/60,AWak(:,i),GV.plotColors(i,:))
    end
    xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_{XW} (f)$', 'Interpreter', 'latex')
    axis([min(f/60) max(f/60) min(min(AWak)) max(max(AWak))])  

    set(gcf,'Position',[100 100 800 600])    
end
