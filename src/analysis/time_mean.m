% time_mean returns the time mean
%   for a given ensemble for each realization
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
% Outputs:
%   time_mean_vector    -> Vector of time mean for each realization
function time_mean_vector = time_mean(ensemble)
    time_mean_vector = zeros(1, size(ensemble, 1));
    for waveform_idx = 1 : size(ensemble, 1)
        SUM = sum(ensemble(waveform_idx, :));
        time_mean_vector(1, waveform_idx) = SUM / size(ensemble, 2);
    end
end