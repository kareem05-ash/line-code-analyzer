% plot_time_acf.m
% Plots the time ACF of one waveform vs statistical ACF
% Arguments
%   - time_acf_vector   -> Time ACF vector for one waveform
%   - stat_acf_vector   -> Statistical ACF vector (for comparison)
%   - title_str         -> Plot title string
function plot_time_acf(time_acf_vector, stat_acf_vector, title_str)
    N       = length(time_acf_vector);
    lags    = -(floor(N/2)) : floor(N/2);

    figure;
    plot(lags, time_acf_vector, 'b',  'LineWidth', 1.5); hold on;
    plot(lags, stat_acf_vector, 'r--','LineWidth', 1.2);
    xlabel('Lag (\tau)');
    ylabel('R_x(\tau)');
    title(title_str);
    legend('Time ACF', 'Statistical ACF');
    grid on;
end