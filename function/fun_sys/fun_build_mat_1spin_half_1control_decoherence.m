function [A,B]  = fun_build_mat_1spin_half_1control_decoherence(G,g,Vsc)
[vG,vg,vVsc]     = ndgrid(G,g,Vsc);
%
vG      = vG(:);
vg      = vg(:);
vVsc    = vVsc(:);
N       = numel(vG);
idx     = 1:N;
%
AG      = [-1 0;0 0];
Ag      = [0 0;0 -1];
Cg      = [0;1];
Bx      = [0 -1;1 0];
%
A       = kron(  sparse(idx,idx,vG,N,N)  ,  AG  ) ...
        + kron(  sparse(idx,idx,vg,N,N)  ,  Ag  );
A       = [[0;kron(vg,Cg)]  [sparse(1,1:2*N,zeros(1,2*N),1,2*N) ;A]];
%
B{1}    = kron(  sparse(idx,idx,vVsc,N,N)  ,  Bx  );
B{1}    = [sparse(idx,1,zeros(1,N),2*N+1,1)  [sparse(1,1:2*N,zeros(1,2*N),1,2*N) ;B{1}]];
%