% gen_rz returns the ensemble after mapping
% Arguments:
%   data      -> Logic data matrix
%   A         -> Amplitude
%   spb       -> Samples per Bit
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