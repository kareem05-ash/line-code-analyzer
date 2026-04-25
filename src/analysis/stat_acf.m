% stat_acf returns the statistical autocorrelation
%   for a given ensemble as a funciton of lag (tau)
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
% Outputs:
%   stat_acf_vector     -> Vector of statistical autocorrelation for each lag (tau)
function stat_acf_vector = stat_acf(ensemble)
    [num_waveforms, num_bits] = size(ensemble);
    lags = 0 : num_bits - 1;
    stat_acf_vector = zeros(1, num_bits);

    for tau = lags
        % for each tau -> multiply x(t) * x(t+tau) then average over t & waveforms
        t_end = num_bits - tau;
        products = ensemble(:, 1:t_end) .* ensemble(:, 1+tau:num_bits);
        stat_acf_vector(tau + 1) = sum(products(:)) / (size(products, 1) * size(products, 2));
    end
end