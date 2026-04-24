clear; clc;
addpath(genpath('src'));

% ====================
% CONTROL FLAGS
% ====================
NUM_WAVEFORMS   = 500;      % no. of waveforms (realizations)
NUM_BITS        = 100;      % no. of bits per one waveform
all             = 4;        % Amplitude

% Data Matrix Genratoin
data = gen_data(NUM_BITS, NUM_WAVEFORMS);