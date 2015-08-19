function [C,gr]     = fun_cost_distance_to_target(u,opt)
DYN = str2func( opt.Dynamics);
y   = DYN(u,opt);
C   = (opt.xf-y(:,end))'*(opt.xf-y(:,end));
if nargout > 1
    p       = -2*(opt.xf-y(:,end))';
    GRAD    = str2func( opt.Gradient );
    gr      = GRAD(u,y,p,opt);
    % Code Debug gradient, compare the gradient provided with complex
    % differentiation
%     grc     = zeros(size(u));
%     Eps     = 1e-12;
%     for i1 = 1:length(u)
%         ut          = u;
%         ut(i1)      = ut(i1) + 1i * Eps;
%         yt          = DYN(ut,opt);
%         grc(i1)     = imag((opt.xf-yt(:,end)).'*(opt.xf-yt(:,end)))/Eps;
%     end
%     [gr(:) grc(:) gr(:)-grc(:)]
%     norm(gr-grc)
end