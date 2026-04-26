% ep_check function {check if process is ergodic or not}
% Arguments
%   - ensemble      -> ensemble 2D Matrix
%   - waveform_idx  -> waveform index
%   - tol           -> tolerance
% Outputs
%   - is_erg        -> bool value {1: ergodic | 0: non-ergodic}
%   - mean_diff     -> difference between time mean & ensemble mean
function [is_erg, mean_diff] = ep_check(ensemble, waveform_idx, tol, type_str)
    % Ensemble Mean (average of stat_mean vector)
        ens_mean    = mean(stat_mean(ensemble));
    % Time Mean (for one waveform)
        t_mean      = time_mean(ensemble, waveform_idx);
    % Difference
        mean_diff   = abs(t_mean - ens_mean);
        is_erg      = mean_diff < tol;
    % Report
        fprintf('\n=== %s ===', type_str);
        fprintf('Ensemble Mean : %.4f\n', ens_mean);
        fprintf('Time Mean     : %.4f\n', t_mean);
        fprintf('Mean Diff     : %.4f\n', mean_diff);
        if is_erg
            fprintf('Process is Ergodic\n\n');
        else
            fprintf('Process is Not Ergodic\n\n');
        end
end