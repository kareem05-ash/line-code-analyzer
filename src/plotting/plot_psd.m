% plot_psd plots the PSD of the ensemble
% Arguments:
%   ensemble  -> Ensemble 2D Matrix
%    TS      ->  % Samples per Bit
%   fig_num   -> Figure Number
%   name      -> Title Name
function plot_psd(ensemble,TS,fig_num,name)
    fs =1/TS*1e-3;

    figure(fig_num)
    hold on;
    for i=1:size(ensemble,1);
        [psd, f] =  pwelch(ensemble(i,:), [], [], [], fs);
        plot(f, 10*log10(psd));
    end
    xlabel ("frequancy (HZ)");
    ylabel  ("PSD (dB)");
    title   (name);
    grid on ;

end

