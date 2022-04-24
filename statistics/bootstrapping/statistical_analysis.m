function [r2, p, bias, rms] = statistical_analysis(data_predicted, data_exp,N)
  nanmask = isnan(data_predicted) | isnan(data_exp);
  data_predicted = data_predicted(~nanmask);
  data_exp = data_exp(~nanmask);
  % number of bootstrap samples
  if nargin < 3; N = 1000; end
  
  % calculate R²
  r2_function = @corrfun;
  [~,p] = r2_function(data_predicted,data_exp);
  [r2]  = find_range(data_predicted,data_exp,length(data_exp),r2_function,N);

  % calculate the bias [dB]
  bias_function = @(pred,expt)(fminsearch(@(x) my_costfun(pred,expt,x),1));
  [bias]        = find_range(data_predicted,data_exp,length(data_exp),bias_function,N);

  % calculate the RMS prediction error [dB]
  rms_function = @(pred,expt)(sqrt(mean((pred-expt).^2)));
  [rms]        = find_range(data_predicted,data_exp,length(data_exp),rms_function,N);
end

function out = my_costfun(xin,yin,x)
  yfun = x + xin;
  out  = sqrt(mean(yin-yfun).^2);
end

function [out,p] = corrfun(pred,expt)
  [out,p] = corrcoef(pred,expt);  
  out = sign(out(1,2))*out(1,2).^2;
  p = p(1,2);
end

function [r,p] = corrfun_spearman(pred,expt)
  N = numel(pred);
  r = 1-6*sum((ranks(pred)-ranks(expt)).^2)/(N*(N*N-1));
  r = sign(r)*r.^2;
  p = nan;
end


function [out] = find_range(data_predicted,data_expected,sample_size,function_handle,N)
  function_output = nan(1,N);
  length_data     = length(data_predicted);
  sample          = nan(1,sample_size);
  mid             = function_handle(data_predicted,data_expected);
  for nth_sample = 1:N  
    data_points         = max(1,ceil(rand(1,sample_size)*length_data));
    sample_predicted    = data_predicted(data_points);
    sample_expected     = data_expected(data_points);
    function_output(nth_sample) = function_handle(sample_predicted,sample_expected);
  end  
  low = quantile(function_output,0.025);
  up  = quantile(function_output,0.975);
  out = [mid low up];
end

%% Sources
% [1] Rediscovering SAS/IML Software: Modern Data Analysis for the Practicing Statistician: http://support.sas.com/resources/papers/proceedings10/329-2010.pdf
