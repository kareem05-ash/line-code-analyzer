% plot_psd.m
% Plots the PSD and marks the bandwidth (first null)
% Arguments
%   - psd_vector    -> PSD vector
%   - freq_vector   -> Frequency axis vector
%   - BW            -> Bandwidth (first null frequency)
%   - title_str     -> Plot title string
function plot_psd(psd_vector, freq_vector, BW, title_str)
    figure;
    plot(freq_vector, psd_vector, 'b', 'LineWidth', 1.5); hold on;

    if ~isnan(BW)
        xline(BW, 'r--', sprintf('BW = %.4f Hz', BW), 'LineWidth', 1.2);
        legend('PSD', 'First Null BW');
    else
        legend('PSD');
    end

    xlabel('Frequency (Hz)');
    ylabel('PSD');
    title(title_str);
    ylim([0, 250]);
    grid on;
end