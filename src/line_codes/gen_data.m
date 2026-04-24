% gen_data function returns a num_bits x num_waveforms MATRIX
function data = gen_data(num_bits, num_waveforms)
    data = randi([0, 1], num_bits, num_waveforms);
end