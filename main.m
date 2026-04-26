clear; clc;
addpath(genpath('src'));

% ========================================
% CONTROL FLAGS
% ========================================
NUM_WAVEFORMS   = 500;      % no. of waveforms (realizations)
NUM_BITS        = 100;      % no. of bits per one waveform
A               = 4;        % Amplitude
TP              = 70e-3;       % Pulse duration
TS              = 10e-3;       % Sampling rate (DAC Activated Period)
SpB             = fix(TP / TS);  % Samples per Bit
t1              = 1;
t2              = 25;
tol             = 0.5;

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