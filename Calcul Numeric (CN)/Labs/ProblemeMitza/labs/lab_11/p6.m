function p6()
  syms x
  type='Hermite';
  f=@(x) sin(x);
  #f=@(x) cos(x);
  n=17;
  aa=[];
  bb=[];
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb);
  I
  quad(@(x) exp(-x.^2).*f(x),-inf,+inf)
endfunction
