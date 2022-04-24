noise_level_dB_SPL = 70;

function out = calc_lvl_per_erb(s,fc,fs,cal)
  if nargin < 4 ; cal = 130 ; end
  erb = @(f) 24.7 * (4.37 * f/1000 + 1);
  el  = fc - erb(fc)/2;
  eh  = fc + erb(fc)/2;
  [b,a] = butter(4,[el eh]/(fs/2));
  sfilt = filter(b,a,s);
  out   = 20 * log10(sqrt(mean(sfilt.^2))) + cal;
end

for jj = 1:100
  [s,fs] = gensweepinnoise(0, 0, '0500,0500');
  out(jj) = calc_lvl_per_erb(s,500,fs,130);
end;
printf('sweepinnoise  (500): %2.1f dB SPL/ERB | %2.1f delta dB SPL to dB SPL/ERB \n', mean(out), mean(out) - noise_level_dB_SPL);

for jj = 1:100
  [s,fs] = gensweepinnoise(0, 0, '1000,1000');
  out(jj) = calc_lvl_per_erb(s,1000,fs,130);
end;
printf('sweepinnoise (1000): %2.1f dB SPL/ERB | %2.1f delta dB SPL to dB SPL/ERB \n', mean(out), mean(out) - noise_level_dB_SPL);

for jj = 1:100
  [s,fs] = gensweepinnoise(0, 0, '2000,2000');
  out(jj) = calc_lvl_per_erb(s,2000,fs,130);
end;
printf('sweepinnoise (2000): %2.1f dB SPL/ERB | %2.1f delta dB SPL to dB SPL/ERB \n', mean(out), mean(out) - noise_level_dB_SPL);

for jj = 1:100
  [s,fs] = gensweepinnoise(0, 0, '4000,4000');
  out(jj) = calc_lvl_per_erb(s,4000,fs,130);
end;
printf('sweepinnoise (4000): %2.1f dB SPL/ERB | %2.1f delta dB SPL to dB SPL/ERB \n', mean(out), mean(out) - noise_level_dB_SPL);
