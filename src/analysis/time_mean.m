% time_mean returns the time mean
%   for a given ensemble for each realization
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
%   waveform_idx        -> Waveform Index
% Outputs:
%   time_mean_val       -> Time Mean Value for a specific waveform
function time_mean_val = time_mean(ensemble, waveform_idx)
    waveform        = ensemble(waveform_idx, :);
    time_mean_val   = sum(waveform) / length(waveform);
end