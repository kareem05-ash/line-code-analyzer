% stat_mean returns the statistical mean
%   for a given ensemble @ each time instant
% Arguments:
%   ensemble            -> Ensemble 2D Matrix
% Outputs:
%   stat_mean_vector    -> Vector of statistical mean @ each time instant
function stat_mean_vector = stat_mean(ensemble)
    stat_mean_vector = zeros(1, size(ensemble, 2));
    for t_idx = 1 : size(ensemble, 2)
        SUM = sum(ensemble(:, t_idx));
        stat_mean_vector(1, t_idx) = SUM / size(ensemble, 1);
    end
end