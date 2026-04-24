% gen_data function returns a num_waveforms x num_bits MATRIX
function data = gen_data(num_waveforms, num_bits)
    data = randi([0, 1], num_waveforms, num_bits);
end