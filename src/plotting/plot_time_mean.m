% plot_time_mean.m
% Plots the time mean for each realization
% Arguments
%   - time_mean_vector  -> Time mean vector (one value per realization)
%   - title_str         -> Plot title string
function plot_time_mean(time_mean_vector, title_str)
    N = length(time_mean_vector);

    figure;
    stem(1:N, time_mean_vector, 'b', 'LineWidth', 1.2);
    yline(mean(time_mean_vector), 'r--', 'LineWidth', 1.2);
    xlabel('Realization Index');
    ylabel('Time Mean');
    title(title_str);
    legend('Time Mean per Realization', 'Average');
    grid on;
end