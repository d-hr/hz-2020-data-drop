function out = bootstrap_fit_nd(ydata,xdata,N);
  # use 1st order polynome in all dimensions
  linear_fun = @(p,x)(linfun_n_dim_1st_order(p,x));
  pdim = size(xdata,2)+1;
  function_output = nan(N,pdim);
  length_data     = size(ydata,1);
  for nth_sample = 1:N
    data_points  = max(1,ceil(rand(1,length_data)*length_data));
    sample_y     = ydata(data_points,:);
    sample_x     = xdata(data_points,:);

    pzero     = randn(pdim,1);
    f2min     = @(p)( get_cost(linear_fun(p,sample_x),sample_y) );
    [popt,~]  = fminsearch(f2min, pzero);
    function_output(nth_sample, :) = popt;
  end
  m   = mean(function_output);
  s   = std(function_output);
  mid = quantile(function_output,0.50,1);
  low = quantile(function_output,0.025,1);
  up  = quantile(function_output,0.975,1);

  out = [m; s; mid; low; up;];
endfunction

function out = get_cost(fitted,observed) % as rmse
  out = log(sqrt(mean((fitted-observed).^2)));
endfunction
