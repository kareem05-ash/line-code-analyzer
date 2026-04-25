function ensample = gen_apply_shift (ensamble_unipolar,spb)
    ensample = zeros(size(ensamble_unipolar));

    for i=1:size(ensamble_unipolar,1)
        amount=randi([1 spb]);

     ensample(i,:) = circshift(ensamble_unipolar(i,:), amount);  % shift each row differently
    end
end

