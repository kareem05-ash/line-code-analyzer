% compute_psd function returns the PSD & BW of a given ACF vector
% Arguments
%   - acf_vector    -> Autocorrelation vector (function of lag (tau))
%   - Ts            -> Sampling period (ms)
% Outputs
%   - psd_vector    -> Power Spectral Density Vector
%   - freq_vector   -> Frequency Axis Vector
%   - BW            -> Bandwidth (first null frequency)
function [psd_vector, freq_vector, BW] = compute_psd(acf_vector, Ts)
    N               = length(acf_vector);
    psd_vector      = abs(fftshift(fft(acf_vector)));
    freq_vector     = (-floor(N/2) : floor(N/2)) / (N * Ts);

    % BW: first null after DC (positive freq only)
        half_psd        = psd_vector(floor(N/2) + 1 : end);
        half_freq       = freq_vector(floor(N/2) + 1 : end);

    % Smooth before null detection
        smooth_window   = 30;   % reduced for better null detection
        half_psd_smooth = movmean(half_psd, smooth_window);

    % Skip DC region (first 5% of samples) before searching for null
        dc_skip         = floor(length(half_psd_smooth) * 0.05);
        search_psd      = half_psd_smooth(dc_skip:end);
        search_freq     = half_freq(dc_skip:end);

    % First near zero crossing
        search_norm     = search_psd / max(half_psd_smooth);
        null_idx        = find(search_norm < 0.02, 1, 'first');

    % Compute BW
        if ~isempty(null_idx)
            BW = search_freq(null_idx);
        else
            BW = NaN;
        end
end