% time_acf returns the time autocorrelation
%   for a single realization as a function of lag (tau)
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
%   waveform_idx        -> Index of the intended waveform
% Outputs:
%   time_acf_vector     -> Time autocorrelation as a function of lag (tau)
function time_acf_vector = time_acf(ensemble, waveform_idx)
    waveform = ensemble(waveform_idx, :);
    num_bits = length(waveform);
    time_acf_vector = zeros(1, num_bits);

    for tau = 0 : num_bits - 1
        t_end = num_bits - tau;
        products = waveform(1 : t_end) .* waveform(1+tau : num_bits);
        time_acf_vector(tau + 1) = sum(products(:)) / (size(products, 1) * size(products, 2));
    end
end