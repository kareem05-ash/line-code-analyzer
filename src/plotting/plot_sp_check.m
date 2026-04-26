% plot_acf.m
% Plots the statistical ACF (avg + @ t1 + @ t2)
% Argumetns
%   - acf_avg       -> ACF averaged over all time instants
%   - acf_t1        -> ACF @ specific time instant t1
%   - acf_t2        -> ACF @ specific time instant t2
%   - t1            -> First time instant index
%   - t2            -> Second time instant index
%   - title_str     -> Plot title string
function plot_sp_check(acf_t1, acf_t2, acf_avg, t1, t2, title_str)
    figure;

    subplot(2, 1, 1);
    plot(acf_t1, 'b', 'LineWidth', 1.5); hold on;
    plot(acf_t2, 'r--', 'LineWidth', 1.2);
    xlabel('\tau'); ylabel('ACF');
    title(sprintf('ACF at t=%d & t=%d', t1, t2));
    legend(sprintf('ACF @ t=%d', t1), sprintf('ACF @ t=%d', t2));
    grid on;

    subplot(2, 1, 2);
    plot(acf_avg, 'b', 'LineWidth', 1.5);
    xlabel('\tau'); ylabel('ACF');
    title('ACF Average');
    grid on;

    sgtitle(title_str);
end