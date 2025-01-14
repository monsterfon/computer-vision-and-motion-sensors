function [A, AW, f] = fnDTFTRGB(x, GV, plotTitle)

L         = length(x); 
n         = 0:L-1;
%% dtft
omega     = linspace(GV.omDTFTMin,GV.omDTFTMax,GV.DTFTNumOfPoints); 
f         = omega/2/pi*GV.fsDeafult*60;
[A] = fnDTFT(x, omega); 
%% windowing
if GV.bitWin
    w          = hann(L); 
    W          = w*ones(1,size(x,2));
    xw         = x.*W;
    [~,AW,~,~] = fnDTFT(xw, omega); 
else
    xw         = x;
    AW         = A;
end

if GV.DebugInterPlot
    figure; sgtitle(plotTitle)
    if GV.bitWin        
        %% time plot
        %% original
        subplot(221), hold on
        for i = 1:size(x,2)
            plot(n,x(:,i),GV.plotColors(i,:))
        end
        xlabel('$n$', 'Interpreter', 'latex'), ylabel('$x[n]$', 'Interpreter', 'latex')
        axis([min(n) max(n) min(min(x)) max(max(x))])
        %% windowed
        subplot(222), hold on
        for i = 1:size(xw,2)
            plot(n,xw(:,i),GV.plotColors(i,:))
        end
        xlabel('$n$', 'Interpreter', 'latex'), ylabel('$x_w[n]$', 'Interpreter', 'latex')
        axis([min(n) max(n) min(min(xw)) max(max(xw))])
        
        %% frequency plot
        %% original
        subplot(223), hold on
        for i = 1:size(x,2)
            plot(f/60,A(:,i),GV.plotColors(i,:))
        end
        xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_X (f)$', 'Interpreter', 'latex')
        axis([min(f/60) max(f/60) min(min(A)) max(max(A))])
        %% windowed
        subplot(224), hold on
        for i = 1:size(x,2)
            plot(f/60,AW(:,i),GV.plotColors(i,:))
        end
        xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_{XW} (f)$', 'Interpreter', 'latex')
        axis([min(f/60) max(f/60) min(min(AW)) max(max(AW))])    
        set(gcf,'Position',[100 100 800 550])  
    else
        %% time plot
        subplot(211), hold on
        for i = 1:size(x,2)
            plot(n,x(:,i),GV.plotColors(i,:))
        end
        xlabel('$n$', 'Interpreter', 'latex'), ylabel('$x[n]$', 'Interpreter', 'latex')
        axis([min(n) max(n) min(min(x)) max(max(x))])
    
        %% frequency plot
        subplot(212), hold on
        for i = 1:size(x,2)
            plot(f/60,A(:,i),GV.plotColors(i,:))
        end
        xlabel('$f$ [Hz]', 'Interpreter', 'latex'), ylabel('$A_X (f)$', 'Interpreter', 'latex')
        axis([min(f/60) max(f/60) min(min(A)) max(max(A))])
   
        set(gcf,'Position',[100 100 450 550]) 
    end
end
