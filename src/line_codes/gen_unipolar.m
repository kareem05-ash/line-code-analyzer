% gen_unipolar returns the ensemble after mapping
% Arguments:
%   data      -> Logic data matrix
%   A         -> Amplitude
%   spb       -> Samples per Bit
% maping:
%   logic (1) -> A
%   logic (0) -> 0
function ensample   = gen_unipolar(data,A,spb)
    map_sig                  = data .* A;
    ensample        = repelem(map_sig,1, spb);
end