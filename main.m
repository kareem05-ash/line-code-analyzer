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

