function p3()
  syms x
  type='Cebisev1';
  f=@(x) x.*exp(-x.^2); # functie impara, integrala e 0
  n=10;
  aa=[];
  bb=[];
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb);
  I
  quad(@(x) x.*exp(-x.^2)./sqrt(1-x.^2),-1,1)
  #rest_f=gauss_rest_sym(1/sqrt(1-x^2),sym(-1),sym(1),nodes)
endfunction
