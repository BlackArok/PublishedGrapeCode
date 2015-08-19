function [c,ceq,Dc,Dceq]  = fun_constr_1rf_1component_max_amp(u,opt)
c       = u.^2 -opt.amp^2;
ceq     = [];
if nargout > 1
    dc      = 2*u;
    idy     = 1:opt.N;
    idx     = 1:opt.N;
    Dc      = sparse(idx,idy,dc,opt.N,opt.N);
    Dceq    = [];
end