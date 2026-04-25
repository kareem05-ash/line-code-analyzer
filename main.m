clear; clc;
addpath(genpath('src'));

% ========================================
% CONTROL FLAGS
% ========================================
NUM_WAVEFORMS   = 10;      % no. of waveforms (realizations)
NUM_BITS        = 5;      % no. of bits per one waveform
A               = 4;        % Amplitude
TP              = 30;       % Pulse duration
TS              = 10;       % Sampling rate (DAC Activated Period)
SpB             = TP / TS;  % Samples per Bit

% =======================================
% Ensemble Generation
% =======================================
% Data Matrix Genratoin
data = gen_data(NUM_WAVEFORMS, NUM_BITS);

% Unipolar ensemble generation
ensemble_unip = gen_unipolar(data, A, SpB);

% Polar NRZ ensemble generation
ensemble_pnrz = gen_polar_nrz(data, A, SpB);

% Polar RZ  ensemble generation
ensemble_prz  = gen_rz(data, A, SpB);

% ========================================
% Time Shift For Each Ensemble
% ========================================
% Apply time shift on Unipolar ensemble
ensemble_shifted_unip = apply_shift(ensemble_unip, SpB);

% Apply time shift on Polar NRZ ensemble
ensemble_shifted_pnrz = apply_shift(ensemble_pnrz, SpB);

% Apply time shift on Polar RZ  ensemble
ensemble_shifted_prz  = apply_shift(ensemble_prz , SpB);

% ========================================
% Analysis
% ========================================
% Statistical Mean Vectors
stat_mean_vector_unip = stat_mean(ensemble_unip);
stat_mean_vector_pnrz = stat_mean(ensemble_pnrz);
stat_mean_vector_prz  = stat_mean(ensemble_prz );

% Time Mean Vectors
time_mean_vector_unip = time_mean(ensemble_unip);
time_mean_vector_pnrz = time_mean(ensemble_pnrz);
time_mean_vector_prz  = time_mean(ensemble_prz );

% Statistical Autocorrelation Vectors
stat_acf_vector_unip  = stat_acf(ensemble_unip);
stat_acf_vector_pnrz  = stat_acf(ensemble_pnrz);
stat_acf_vector_prz   = stat_acf(ensemble_prz );

% Time Autocorrelation Vectors
time_acf_vector_unip  = time_acf(ensemble_unip, 1);
time_acf_vector_pnrz  = time_acf(ensemble_pnrz, 1);
time_acf_vector_prz   = time_acf(ensemble_prz , 1);
