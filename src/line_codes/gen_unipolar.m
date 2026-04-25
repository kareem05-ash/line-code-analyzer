% gen_unipolar.m returns the ensemble after mapping
% Arguments:
%   data      -> Logic data matrix
%   A         -> Amplitude
%   spb       -> Samples per Bit
% maping:
%   logic (1) -> A
%   logic (0) -> 0
function ensemble = gen_unipolar(data, A, spb)
    mapped = data .* A;
    ensemble = repelem(mapped, 1, spb);
end