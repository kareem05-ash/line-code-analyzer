% plots the statistical mean of the ensemble
% Arguments:
%   ensemble        -> Ensemble 2D Matrix
%   fig_num         -> Figure Number
%   sp_num          -> Subplot number
%   name            -> Title Name
function plot_mean (ensemble,fig_num,sp_num,name)

    stat_mean_vector = stat_mean(ensemble);

    figure (fig_num)
    subplot(3,1,sp_num);
    plot(stat_mean_vector)
    xlabel("Time");
    ylabel("statistical mean");
    title (name);
    grid on;
end


    