% gen_polar_nrz returns the ensemble after mapping
% Arguments:
%   data      -> Logic data matrix
%   A         -> Amplitude
%   spb       -> Samples per Bit
% maping:
%   logic (1) -> A
%   logic (0) -> -A
function ensemble = gen_polar_nrz(data, A, spb)
    mapped = (2 * data - 1) * A;
    ensemble = repelem(mapped, 1, spb);
end