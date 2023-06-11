function p1()
  syms x
  type='Jacobi';
  f=@(x) sin(x);
  n=4;
  aa=1;
  bb=1;
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb)
endfunction
