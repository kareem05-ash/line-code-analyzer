clear; clc;
% ==================
% CONTROL FLAGS
% ==================
NUM_WAVEFORMS   = 500;      % no. of waveforms (realizations)
NUM_BITS        = 100;      % no. of bits per one waveform
A               = 4;        % Amplitude
TP              = 70e-3;       % Pulse duration
TS              = 10e-3;       % Sampling rate (DAC Activated Period)
SpB             = fix(TP / TS);  % Samples per Bit
t1              = 1;
t2              = 25;
tol             = 0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==================
% LINE CODES
% ==================
% gen_data function returns a num_waveforms x num_bits MATRIX
function data = gen_data(num_waveforms, num_bits)
    data = randi([0, 1], num_waveforms, num_bits);
end

% maping:
%   logic (1) -> A
%   logic (0) -> 0
function ensemble = gen_unipolar(data, A, spb)
    mapped = data .* A;
    ensemble = repelem(mapped, 1, spb);
end

% maping:
%   logic (1) -> A
%   logic (0) -> -A
function ensemble = gen_polar_nrz(data, A, spb)
    mapped = (2 * data - 1) * A;
    ensemble = repelem(mapped, 1, spb);
end

% maping:
%   logic (1) -> A      for half of the period
%   logic (0) -> -A     for half of the period
function ensemble = gen_rz(data, A, spb)
    num_waveforms = size(data, 1);
    num_bits = size(data, 2);
    mapped = (2 * data - 1) * A;
    Ton  = fix(spb / 2);     % force integer division (7/2 = 3)
    Toff = spb - Ton;

    on_part  = repelem(mapped, 1, Ton);
    off_part = repelem(zeros(size(mapped)), 1, Toff);

    % Concatination: for each bit (on_part samples -> off_part samples)
    ensemble = zeros(num_waveforms, num_bits * spb);

    for b = 1 : num_bits
        % {1st iteration} -> on_idx  = [1 2 3] = 1 : 3
        on_idx  = (b-1)*spb + 1 : (b-1)*spb + Ton;  
        % {1st iteration} -> off_idx = [4 5 6 7] = 4 : 7    
        off_idx = (b-1)*spb + Ton + 1 : b*spb;          
        ensemble(:, on_idx)  = on_part(:, (b-1)*Ton+1 : b*Ton);
        ensemble(:, off_idx) = off_part(:, (b-1)*Toff+1 : b*Toff);
    end
end

% apply_shift returns the ensemble after applying random time shift
% Arguments:
%   ensemble  -> Normal ensemble 2D Matrix
%   spb       -> Samples per Bit
function ensemble_shifted = apply_shift(ensemble, spb)
    ensemble_shifted = ensemble;  % copy to output first
    for waveform_idx = 1 : size(ensemble, 1)
        shamt = randi([1, spb-1], 1, 1);
        ensemble_shifted(waveform_idx, :) = circshift(ensemble(waveform_idx, :), shamt);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==================
% ANALYSIS
% ==================
% stat_mean returns the statistical mean
%   for a given ensemble @ each time instant
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
% Outputs:
%   stat_mean_vector    -> Vector of statistical mean @ each time instant
function stat_mean_vector = stat_mean(ensemble)
    stat_mean_vector = zeros(1, size(ensemble, 2));
    for t_idx = 1 : size(ensemble, 2)
        SUM = sum(ensemble(:, t_idx));
        stat_mean_vector(1, t_idx) = SUM / size(ensemble, 1);
    end
end

% stat_acf function returns the statistical autocorrelation
%   for a given ensemble as a funciton of lag (tau)
% Arguments
%   - ensemble          -> ensemble 2D Matrix
% Outputs
%   - stat_acf_vector   -> Vector of statistical autocorrelation for each lag (tau)
%                           lag range: - (num_bits - 1) passign by (0) up to + (num_bits - 1)
%                               for 700 samples -> lag range: -699 : +699
function stat_acf_vector = stat_acf(ensemble)
    [num_waveforms, num_bits] = size(ensemble);
    lags = 0 : num_bits - 1;
    acf_positive = zeros(1, num_bits);

    for tau = lags
        t_end = num_bits - tau;
        products = ensemble(:, 1:t_end) .* ensemble(:, 1+tau:num_bits);
        acf_positive(tau + 1) = sum(products(:)) / (size(products, 1) * size(products, 2));
    end

    % Full ACF: mirror positive side
        stat_acf_vector = [fliplr(acf_positive(2 : end)), acf_positive];
end

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==================
% PLOTTING
% ==================
% plot_mean.m
% Plots the statistical mean vector over time
% Arguments
%   - stat_mean_vector  -> Statistical Mean Vector
%   - Ts                -> Sampling Period (ms)
%   - title_str         -> Plot Title String
function plot_mean(stat_mean_vector, Ts, title_str)
    N           = length(stat_mean_vector);
    t_axsis     = (0 : N-1) * Ts;

    figure;
    plot(t_axsis, stat_mean_vector, 'b', 'LineWidth', 1.5);
    yline(mean(stat_mean_vector), 'r--', 'LineWidth', 1.2);
    xlabel('Time (ms)');
    ylabel('Amplitude');
    title(title_str);
    legend('Statistical Mean', 'Average');
    grid on;
end

% plot_time_mean.m
% Plots the time mean for each realization
% Arguments
%   - time_mean_vector  -> Time mean vector (one value per realization)
%   - title_str         -> Plot title string
function plot_time_mean(time_mean_vector, title_str)
    N = length(time_mean_vector);

    figure;
    stem(1:N, time_mean_vector, 'b', 'LineWidth', 1.2);
    yline(mean(time_mean_vector), 'r--', 'LineWidth', 1.2);
    xlabel('Realization Index');
    ylabel('Time Mean');
    title(title_str);
    legend('Time Mean per Realization', 'Average');
    grid on;
end

% plot_time_acf.m
% Plots the time ACF of one waveform vs statistical ACF
% Arguments
%   - time_acf_vector   -> Time ACF vector for one waveform
%   - stat_acf_vector   -> Statistical ACF vector (for comparison)
%   - title_str         -> Plot title string
function plot_time_acf(time_acf_vector, stat_acf_vector, title_str)
    N       = length(time_acf_vector);
    lags    = -(floor(N/2)) : floor(N/2);

    figure;
    plot(lags, time_acf_vector, 'b',  'LineWidth', 1.5); hold on;
    plot(lags, stat_acf_vector, 'r--','LineWidth', 1.2);
    xlabel('Lag (\tau)');
    ylabel('R_x(\tau)');
    title(title_str);
    legend('Time ACF', 'Statistical ACF');
    grid on;
end

% plot_acf.m
% Plots the statistical ACF (avg + @ t1 + @ t2)
% Argumetns
%   - acf_avg       -> ACF averaged over all time instants
%   - acf_t1        -> ACF @ specific time instant t1
%   - acf_t2        -> ACF @ specific time instant t2
%   - t1            -> First time instant index
%   - t2            -> Second time instant index
%   - title_str     -> Plot title string
function plot_sp_check(acf_t1, acf_t2, acf_avg, t1, t2, title_str)
    figure;

    subplot(2, 1, 1);
    plot(acf_t1, 'b', 'LineWidth', 1.5); hold on;
    plot(acf_t2, 'r--', 'LineWidth', 1.2);
    xlabel('\tau'); ylabel('ACF');
    title(sprintf('ACF at t=%d & t=%d', t1, t2));
    legend(sprintf('ACF @ t=%d', t1), sprintf('ACF @ t=%d', t2));
    grid on;

    subplot(2, 1, 2);
    plot(acf_avg, 'b', 'LineWidth', 1.5);
    xlabel('\tau'); ylabel('ACF');
    title('ACF Average');
    grid on;

    sgtitle(title_str);
end

% plot_psd.m
% Plots the PSD and marks the bandwidth (first null)
% Arguments
%   - psd_vector    -> PSD vector
%   - freq_vector   -> Frequency axis vector
%   - BW            -> Bandwidth (first null frequency)
%   - title_str     -> Plot title string
function plot_psd(psd_vector, freq_vector, BW, title_str)
    figure;
    plot(freq_vector, psd_vector, 'b', 'LineWidth', 1.5); hold on;

    if ~isnan(BW)
        xline(BW, 'r--', sprintf('BW = %.4f Hz', BW), 'LineWidth', 1.2);
        legend('PSD', 'First Null BW');
    else
        legend('PSD');
    end

    xlabel('Frequency (Hz)');
    ylabel('PSD');
    title(title_str);
    ylim([0, 250]);
    grid on;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==================
% << MAIN >>
% ==================
% =======================================
% Ensemble Generation
% =======================================
data = gen_data(NUM_WAVEFORMS, NUM_BITS);
ensemble_unip = gen_unipolar(data, A, SpB);
ensemble_pnrz = gen_polar_nrz(data, A, SpB);
ensemble_prz  = gen_rz(data, A, SpB);

% ========================================
% Time Shift For Each Ensemble
% ========================================
ensemble_shifted_unip = apply_shift(ensemble_unip, SpB);
ensemble_shifted_pnrz = apply_shift(ensemble_pnrz, SpB);
ensemble_shifted_prz  = apply_shift(ensemble_prz , SpB);

% ========================================
% Statistical Mean & Autocorrelation
% ========================================
stat_mean_vector_unip       = stat_mean(ensemble_shifted_unip);
stat_mean_vector_pnrz       = stat_mean(ensemble_shifted_pnrz);
stat_mean_vector_prz        = stat_mean(ensemble_shifted_prz );

stat_acf_vector_avg_unip    = stat_acf(ensemble_shifted_unip);
stat_acf_vector_t1_unip     = stat_acf_at(ensemble_shifted_unip, t1);
stat_acf_vector_t2_unip     = stat_acf_at(ensemble_shifted_unip, t2);

stat_acf_vector_avg_pnrz    = stat_acf(ensemble_shifted_pnrz);
stat_acf_vector_t1_pnrz     = stat_acf_at(ensemble_shifted_pnrz, t1);
stat_acf_vector_t2_pnrz     = stat_acf_at(ensemble_shifted_pnrz, t2);

stat_acf_vector_avg_prz     = stat_acf(ensemble_shifted_prz );
stat_acf_vector_t1_prz      = stat_acf_at(ensemble_shifted_prz, t1);
stat_acf_vector_t2_prz      = stat_acf_at(ensemble_shifted_prz, t2);

plot_mean(stat_mean_vector_unip, TS, 'Statistical Mean for Unipolar');
plot_mean(stat_mean_vector_pnrz, TS, 'Statistical Mean for Polar NRZ');
plot_mean(stat_mean_vector_prz , TS, 'Statistical Mean for Polar RZ');

% ========================================
% Stationarity Proof (Visual)
% ========================================
plot_sp_check(stat_acf_vector_t1_unip, stat_acf_vector_t2_unip, stat_acf_vector_avg_unip, t1, t2, 'Stationarity Proof - Unipolar');
plot_sp_check(stat_acf_vector_t1_pnrz, stat_acf_vector_t2_pnrz, stat_acf_vector_avg_pnrz, t1, t2, 'Stationarity Proof - Polar NRZ');
plot_sp_check(stat_acf_vector_t1_prz,  stat_acf_vector_t2_prz,  stat_acf_vector_avg_prz,  t1, t2, 'Stationarity Proof - Polar RZ');

% ========================================
% Time Mean & Autocorrelation
% ========================================
waveform_idx = 1;

time_mean_unip = time_mean(ensemble_shifted_unip, waveform_idx);
time_mean_pnrz = time_mean(ensemble_shifted_pnrz, waveform_idx);
time_mean_prz  = time_mean(ensemble_shifted_prz,  waveform_idx);

time_acf_unip  = time_acf(ensemble_shifted_unip, waveform_idx);
time_acf_pnrz  = time_acf(ensemble_shifted_pnrz, waveform_idx);
time_acf_prz   = time_acf(ensemble_shifted_prz,  waveform_idx);

plot_time_mean(time_mean_unip, sprintf("Time Mean for Waveform (idx = %0d) of Unipolar ensemble", waveform_idx));
plot_time_mean(time_mean_pnrz, sprintf("Time Mean for Waveform (idx = %0d) of Polra NRZ ensemble", waveform_idx));
plot_time_mean(time_mean_prz, sprintf("Time Mean for Waveform (idx = %0d) of Polar RZ ensemble", waveform_idx));

plot_time_acf(time_acf_unip, stat_acf_vector_avg_unip, sprintf("Time ACF for Waveform (idx = %0d) of Unipolar ensemble", waveform_idx));
plot_time_acf(time_acf_pnrz, stat_acf_vector_avg_pnrz, sprintf("Time ACF for Waveform (idx = %0d) of Polra NRZ ensemble", waveform_idx));
plot_time_acf(time_acf_prz, stat_acf_vector_avg_prz, sprintf("Time ACF for Waveform (idx = %0d) of Polar RZ ensemble", waveform_idx));

fprintf('=== Time Mean ===\n');
fprintf('Unipolar  : %.4f\n', time_mean_unip);
fprintf('Polar NRZ : %.4f\n', time_mean_pnrz);
fprintf('Polar RZ  : %.4f\n', time_mean_prz);

% ========================================
% Ergodic Process Check
% ========================================
is_erg_unip = ep_check(ensemble_shifted_unip, waveform_idx, tol, 'Unipolar');
is_erg_pnrz = ep_check(ensemble_shifted_pnrz, waveform_idx, tol, 'Polar NRZ');
is_erg_prz  = ep_check(ensemble_shifted_prz,  waveform_idx, tol, 'Polar RZ');

% ========================================
% PSD & BW
% ========================================
[psd_unip, freq_unip, BW_unip] = compute_psd(stat_acf_vector_avg_unip, TS);
[psd_pnrz, freq_pnrz, BW_pnrz] = compute_psd(stat_acf_vector_avg_pnrz, TS);
[psd_prz,  freq_prz,  BW_prz]  = compute_psd(stat_acf_vector_avg_prz,  TS);

plot_psd(psd_unip, freq_unip, BW_unip, 'PSD for Unipolar');
plot_psd(psd_pnrz, freq_pnrz, BW_pnrz, 'PSD for Polar NRZ')
plot_psd(psd_prz,  freq_prz,  BW_prz , 'PSD for Polar RZ')

fprintf('BW Unipolar  : %.4f Hz\n', BW_unip);
fprintf('BW Polar NRZ : %.4f Hz\n', BW_pnrz);
fprintf('BW Polar RZ  : %.4f Hz\n', BW_prz);