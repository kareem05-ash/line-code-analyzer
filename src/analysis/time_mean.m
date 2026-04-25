% time_mean returns the time mean
%   for a given ensemble for each realization
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
% Outputs:
%   time_mean_vector    -> Vector of time mean for each realization
function time_mean_vector = time_mean(ensemble,waveform_idx)

        SUM = sum(ensemble(waveform_idx, :));
        time_mean_vector = SUM / size(ensemble, 2);

end