% plot_mean.m
% Plots the statistical mean vector over time
% Arguments
%   - stat_mean_vector  -> Statistical Mean Vector
%   - Ts                -> Sampling Period (ms)
%   - title_str         -> Plot Title String
function plot_mean(stat_mean_vector, Ts, title_str)
    N           = length(stat_mean_vector);
    t_axsis     = (0 : N-1) * Ts;

    figure;
    plot(t_axsis, stat_mean_vector, 'b', 'LineWidth', 1.5);
    yline(mean(stat_mean_vector), 'r--', 'LineWidth', 1.2);
    xlabel('Time (ms)');
    ylabel('Amplitude');
    title(title_str);
    legend('Statistical Mean', 'Average');
    grid on;
end