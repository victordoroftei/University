function p2()
  syms x
  type='Legendre';
  f=@(x) sin(x).^2;
  #f=@(x) cos(x).^2;
  n=5;
  aa=[];
  bb=[];
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb);
  I
  syms theta
  rest_f=gauss_rest_sym(sym(1),sym(-1),sym(1),nodes)
  eval(subs(rest_f,theta,sym(2)^(length(nodes))))
endfunction
