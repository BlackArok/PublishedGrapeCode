function [c,ceq,Dc,Dceq]  = fun_constr_1rf_2component_max_amp(u,opt)
c       = u(1:opt.N).^2 + u((1:opt.N)+opt.N).^2-opt.amp^2;
ceq     = [];
if nargout > 1
    dc      = 2*u;
    idy     = [1:opt.N 1:opt.N];
    idx     = 1:2*opt.N;
    Dc      = sparse(idx,idy,dc,2*opt.N,opt.N);
    Dceq    = [];
end