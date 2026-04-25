clear; clc;
addpath(genpath('src'));

% ====================
% CONTROL FLAGS
% ====================
NUM_WAVEFORMS   = 10;      % no. of waveforms (realizations)
NUM_BITS        = 5;      % no. of bits per one waveform
A               = 4;        % Amplitude
TP              = 70;       % Pulse duration
TS              = 10;       % Sampling rate (DAC Activated Period)
SpB             = TP / TS;  % Samples per Bit

% Data Matrix Genratoin
data = gen_data(NUM_WAVEFORMS, NUM_BITS);

% Polar NRZ ensemble generation
ensemble_pnrz      = gen_polar_nrz(data, A, SpB);

% Polar RZ  ensemble generation
ensemble_prz       = gen_rz(data, A, SpB);

% unipolar  ensemble generation
ensemble_unipolar  = gen_unipolar(data, A, SpB);

%apply shift yo ensamble
shifted_ensamble   =gen_apply_shift(ensemble_unipolar,spb);