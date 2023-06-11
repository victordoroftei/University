function p4()
  syms x
  type='Cebisev2';
  f=@(x) exp(-x.^2);
  n=10;
  aa=[];
  bb=[];
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb);
  I
  quad(@(x) exp(-x.^2).*sqrt(1-x.^2),-1,1)
  #rest_f=gauss_rest_sym(sqrt(1-x^2),sym(-1),sym(1),nodes)
endfunction
