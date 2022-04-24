function [r2_p, bias_p, rms_p] = comparative_analysis_two_sided(emp_data, mod1_data, mod2_data, N)
% Some statistics % i.e., Is "mod1_data" siginificantly different from "mod2_data"?

  % calculate R²
  r2_function = @corrfun;
  [r2_p] = make_comparison(emp_data, mod1_data, mod2_data, r2_function, N);

  % calculate the bias [dB]
  bias_function = @find_bias;
  [bias_p] = make_comparison(emp_data, mod1_data, mod2_data, bias_function, N);

  % calculate the RMS prediction error [dB]
  rms_function = @(pred,expt)(sqrt(mean((pred-expt).^2)));
  [rms_p] = make_comparison(emp_data, mod1_data, mod2_data, rms_function,N);
end

function out = find_bias(pred,expt)
  out = abs(fminsearch(@(x) my_costfun(pred,expt,x),1));
end

function out = my_costfun(xin,yin,x)
  yfun = x + xin;
  out = sqrt(mean(yin-yfun).^2);
end

function out = corrfun(pred,expt)
  out = corrcoef(pred,expt);
  out = sign(out(1,2))*out(1,2).^2;
  #out = sign(out)*out.^2;
end

function p = make_comparison(emp_data, mod1_data, mod2_data, funhandle, num_samples)
  hist_data = nan(num_samples,1);
  parfor i=1:num_samples
    idx = max(1,ceil(rand(1,numel(emp_data)).*numel(emp_data)));
    emp_data_tmp  = emp_data(idx);
    mod1_data_tmp = mod1_data(idx);
    mod2_data_tmp = mod2_data(idx);
    value1 = funhandle(mod1_data_tmp,emp_data_tmp);
    value2 = funhandle(mod2_data_tmp,emp_data_tmp);

    hist_data(i) = value2 - value1;
  end
  % mean of resulting distribution
  mu       = mean(hist_data); ...
  % flip direction of distribution
  % -> mean always positive, easier test for p values
  directional_factor = sign(mu);
  % mean is diff to zero, and zero is the boundary that defines which model performed better.
  % -> we want to check, which model performs better
  % -> p-values describe which data are more extreme than our observations, therefore we need this two-sided test
  p_left  = sum(directional_factor*hist_data < 0) / numel(hist_data);
  p_right = sum(directional_factor*hist_data > directional_factor*mu*2) / numel(hist_data);
  p = p_left + p_right;
end
