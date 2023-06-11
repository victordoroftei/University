function [I,nodes,coefs]=gauss_quad_num(type,f,n,aa=[],bb=[])
  [alpha,beta]=orto_coef_num_type(type,0:n-1,aa,bb);
  J=diag(alpha)+diag(sqrt(beta(2:end)),-1)+diag(sqrt(beta(2:end)),1);
  [V,x]=eig(J,'vector');
  coefs=beta(1)*V(1,:).^2;
  I=coefs*f(x);
  nodes=x';
endfunction
