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