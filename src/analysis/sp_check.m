% sp_check function {check if process is stationary or not}
% Arguments
%   - ensemble          -> ensemble 2D Matrix
%   - num_waveforms     -> no. of waveforms
%   - num_samples       -> no. of samples
%   - fig_num           -> figure number
%   - title_str         -> plot title string
% Outputs
%   - is_stat           -> bool value {1: stationary | 0: non-stationary}
function is_stat = sp_check(ensemble, num_waveforms, num_samples, fig_num, title_str)
    mean_thr    = 0.1;
    acf_thr     = 0.5;

    % Mean Check
        mean_vec    = stat_mean(ensemble);
        mean_var    = var(mean_vec);
        is_stat_mean = mean_var < mean_thr;

    % ACF Check
    % ACF(t, tau) = E[x(t) * x(t+tau)]
        t1      = 1;
        t2      = 80;

        acf_t1  = zeros(1, num_samples);
        for tau = 0 : num_samples - t1 - 1
            acf_t1(1+tau) = sum(ensemble(:,t1) .* ensemble(:,t1+tau)) / num_waveforms;
        end

        acf_t2  = zeros(1, num_samples);
        for tau = 0 : num_samples - t2 - 1
            acf_t2(1+tau) = sum(ensemble(:,t2) .* ensemble(:,t2+tau)) / num_waveforms;
        end

        min_len     = min(length(acf_t1), length(acf_t2));
        acf_diff    = mean(abs(acf_t1(1:min_len) - acf_t2(1:min_len)));
        is_stat_acf = acf_diff < acf_thr;

    % Is Stationary
        is_stat = is_stat_mean && is_stat_acf;

    % Report
        fprintf('=== Stationarity Check: %s ===\n', title_str);
        fprintf('Mean Variance : %.4f\n', mean_var);
        fprintf('ACF Diff      : %.4f\n', acf_diff);
        if is_stat
            fprintf('Process is Stationary\n\n');
        else
            fprintf('Process is Not Stationary\n\n');
        end

    % Plotting
        figure(fig_num);

        subplot(3, 1, 1);
        plot(acf_t1, 'b', 'LineWidth', 1.5); hold on;
        plot(acf_t2, 'r--', 'LineWidth', 1.2);
        xlabel('\tau'); ylabel('ACF');
        title(sprintf('ACF at t=%d & t=%d', t1, t2));
        legend(sprintf('ACF @ t=%d', t1), sprintf('ACF @ t=%d', t2));
        grid on;

        subplot(3, 1, 2);
        acf_avg = (acf_t1(1:min_len) + acf_t2(1:min_len)) / 2;
        plot(acf_avg, 'b', 'LineWidth', 1.5);
        xlabel('\tau'); ylabel('ACF');
        title('ACF Average');
        grid on;

        subplot(3, 1, 3);
        plot(mean_vec, 'b', 'LineWidth', 1.5);
        yline(mean(mean_vec), 'r--', 'LineWidth', 1.2);
        xlabel('Time'); ylabel('Mean');
        title('Statistical Mean');
        legend('Mean Vector', 'Average');
        grid on;

        sgtitle(title_str);
end