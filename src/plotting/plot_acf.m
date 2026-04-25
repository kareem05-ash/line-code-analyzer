% plots Autocorrelation function
% Arguments:
%   ensemble        -> Ensemble 2D Matrix
%   fig_num         -> Figure Number
%   sp_num          -> Subplot number
%   name            -> Title Name

function plot_acf (ensemble,fig_num,sp_num,name)

    acf_vector =stat_acf (ensemble);

    figure (fig_num)
    subplot(3,1,sp_num);
    plot(acf_vector)
    xlabel("Time");
    ylabel("Autocorrelation function");
    title (name);
    grid on;
end


    