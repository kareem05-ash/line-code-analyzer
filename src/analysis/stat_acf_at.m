% stat_acf_at function reutrns the statstical autocorrelation
%   for a given ensemble @ a specific time instant t
% Arguments
%   - ensemble          -> ensemble 2D Matrix
%   - t1                -> specific time instant
% Outputs
%   - stat_acf_vector   -> Vector fo statistical autocorrelation for each lag (tau)
%                           lag range: - (num_bits - 1) passign by (0) up to + (num_bits - 1)
%                               for 700 samples -> lag range: -699 : +699
function stat_acf_vector = stat_acf_at(ensemble, t1)
    [num_waveforms, num_bits] = size(ensemble);
    lags = 0 : num_bits - 1;
    acf_positive = zeros(1, num_bits);

    for tau = lags
        t2 = t1 + tau;
        if t2 > num_bits
            break;  % out of bounds
        end
        
        products = ensemble(:, t1) .* ensemble(:, t2);
        acf_positive(tau + 1) = sum(products(:)) / (size(products, 1) * size(products, 2));

            % Full ACF: mirror positive side
        stat_acf_vector = [fliplr(acf_positive(2 : end)), acf_positive];
    end
end