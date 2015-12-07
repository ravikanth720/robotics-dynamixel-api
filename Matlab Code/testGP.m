  close all
 
  meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [0.5; 1];
  covfunc = {@covMaterniso, 3}; ell = 1/4; sf = 1; hyp.cov = log([ell; sf]);
  likfunc = @likGauss; sn = 0.1; hyp.lik = log(sn);
  
  nlml = gp(hyp, @infExact, meanfunc, covfunc, likfunc, input(:,1), output(:,1))
  [m s2] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, input(:,1), output(:,1), output(:,1));

  f = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)]; 
  fill([output(:,1); flipdim(z,1)], f, [7 7 7]/8)
  hold on; plot(output(:,1), m); plot(input(:,1), output(:,1), '+')