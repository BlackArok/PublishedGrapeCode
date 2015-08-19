function [A,B]  = fun_build_mat_1spin_half_2control_decoherence(G,g,delta,Vsc)
[vG,vg,vdelta,vVsc]     = ndgrid(G,g,delta,Vsc);
%
vG      = vG(:);
vg      = vg(:);
vdelta  = vdelta(:);
vVsc    = vVsc(:);
N       = numel(vG);
idx     = 1:N;
%
AG      = [-1 0 0;0 -1 0;0 0 0];
Ag      = [0 0 0;0 0 0;0 0 -1];
Cg      = [0;0;1];
Ad      = [0 -1 0;1 0 0;0 0 0];
Bx      = [0 0 0;0 0 -1;0 1 0];
By      = [0 0 1;0 0 0;-1 0 0];
%
A       = kron(  sparse(idx,idx,vG,N,N)  ,  AG  ) ...
        + kron(  sparse(idx,idx,vg,N,N)  ,  Ag  ) ...
        + kron(  sparse(idx,idx,vdelta,N,N)  ,  Ad  );
A       = [[0;kron(vg,Cg)]  [sparse(1,1:3*N,zeros(1,3*N),1,3*N) ;A]];
%
B{1}    = kron(  sparse(idx,idx,vVsc,N,N)  ,  Bx  );
B{2}    = kron(  sparse(idx,idx,vVsc,N,N)  ,  By  );
B{1}    = [sparse(idx,1,zeros(1,N),3*N+1,1)  [sparse(1,1:3*N,zeros(1,3*N),1,3*N) ;B{1}]];
B{2}    = [sparse(idx,1,zeros(1,N),3*N+1,1)  [sparse(1,1:3*N,zeros(1,3*N),1,3*N) ;B{2}]];
%
% figure;hold on;box on;
%     spy(A,'r.')
%     spy(B{1},'bo')
%     spy(B{2},'gs')