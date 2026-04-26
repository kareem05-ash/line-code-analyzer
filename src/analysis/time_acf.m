% time_acf returns the time autocorrelation
%   for a single realization as a function of lag (tau)
% Arguments:
%   - ensemble            -> Ensemble 2D Matrix
%   - waveform_idx        -> Index of the intended waveform
% Outputs:
%   - time_acf_vector     -> Time autocorrelation as a function of lag (tau)
%                               lag range: - (num_bits - 1) passign by (0) up to + (num_bits - 1)
%                                   for 700 samples -> lag range: -699 : +699
function time_acf_vector = time_acf(ensemble, waveform_idx)
    waveform = ensemble(waveform_idx, :);
    num_bits = length(waveform);
    acf_positive = zeros(1, num_bits);

    for tau = 0 : num_bits - 1
        t_end = num_bits - tau;
        products = waveform(1 : t_end) .* waveform(1+tau : num_bits);
        acf_positive(tau + 1) = sum(products(:)) / (size(products, 1) * size(products, 2));
    end

    % Full ACF: mirror positive side
        time_acf_vector = [fliplr(acf_positive(2 : end)), acf_positive];
end