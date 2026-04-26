% Stationary Process Check
% Arguments:
%   ensemble        -> Ensemble 2D Matrix
%   num_waveforms    -> no. of waveforms
%   num_samples     -> no. of samples
% Therashold values:
%   mean_thr        -> mean threshold
%   acf_thr         -> acf threshold
function sp_check(ensemble,num_waveforms,num_samples,fig_num)

    mean_thr    = 0.1;
    acf_thr     = 0.5;

    % Mean check
    mean_vec    = stat_mean(ensemble);
    mean_var    = var(mean_vec);
    
    % ACF check
    % ACF (t,tau) = E(x(t) * x(t+tau))
    t1 = 1;
    t2 = 80;

    acf_t1 = zeros(1,num_samples);
    for tau = 0: num_samples - t1 - 1
        acf_t1(1+tau) = sum(ensemble(:,t1) .* ensemble(:,t1+tau)) / num_waveforms;
    end 

    acf_t2 = zeros(1,num_samples);
    for tau = 0: num_samples - t2 - 1
        acf_t2(1+tau) = sum(ensemble(:,t2) .* ensemble(:,t2+tau)) / num_waveforms;
    end 

    % plot ACF at t = t1,t2 and the average
    figure (fig_num)
    subplot(3,1,1)
    plot (acf_t1);
    hold on;
    plot (acf_t2);
    legend;
    xlabel ("tau");
    ylabel ("ACF");
    title  ("ACF at t=t1 & t=t2")
    grid on ;

    subplot (3,1,2)
    min_len  = min(length(acf_t1), length(acf_t2));
    acf_avg  = (acf_t1(1:min_len) + acf_t2(1:min_len)) / 2; 

    plot (acf_avg);
    xlabel ("tau");
    ylabel ("ACF");
    title ("ACF average");
    grid on ;

    acf_diff = mean (acf_avg);
    fprintf ('Mean variance : .%4f\n ' ,  mean_var);
    fprintf ('ACF diff      : .%4f\n', acf_diff);

    if mean_var < mean_thr && acf_diff <acf_thr
        fprintf ("Process is Stationary\n");
    else 
        fprintf ("Prosess is Not Stationary\n");
    end
end
