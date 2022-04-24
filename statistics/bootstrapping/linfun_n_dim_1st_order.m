function out = linfun_n_dim_1st_order(p,x)
  out = p(end);
  for ii = 1:length(p)-1
    out = out + p(ii) * x(:,ii);
  end
endfunction
