function [t_one_tailed, t_two_tailed] = givetThresh(group_size1, group_size2)
% written by chatGPT, credit where it's due. Thanks bud
    % Calculate the degrees of freedom
    df = group_size1 + group_size2 - 2;
    
    % Set the significance level (alpha)
    alpha = 0.05;
    
    % Calculate the t-critical value for a two-tailed test
    t_two_tailed = tinv(1 - alpha / 2, df);
    
    % Calculate the t-critical value for a one-tailed test (positive direction)
    t_one_tailed = tinv(1 - alpha, df);
end