% Stationary Process Check
% Arguments:
%   ensemble        -> Ensemble 2D Matrix
% Therashold values:
%   mean_thr        -> mean threshold
%   acf_thr         -> acf threshold
function sp_check(ensemble)

    mean_thr    = 0.1;
    acf_thr     = 0.5; 
    mean_vec    = stat_mean(ensemble);
    acf_vec     = stat_acf(ensemble);
    mean_var    = var(mean_vec);
    acf_end     = abs(acf_vec(end));
    
    if mean_var < mean_thr && acf_end <acf_thr 
        fprintf ('Process is Stationary\n');
        fprintf ('Mean variance : %.6f < %.2f\n', mean_var, mean_thr);
        fprintf ('ACF at end = %.4f < %.4f\n',acf_end,acf_thr);
    else
    fprintf('Process is NOT STATIONARY \n');
    fprintf('Mean variance : %.6f\n', mean_var);
    fprintf('ACF at end    : %.6f\n', acf_end);
    end


    %not complete 


