function p5()
  syms x
  type='Laguerre';
  f=@(x) sin(x);
  #f=@(x) cos(x);
  n=17;
  aa=0;
  bb=[];
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb);
  I
  quad(@(x) exp(-x).*f(x),0,+inf)

  syms theta
  rest_f=gauss_rest_sym(exp(-x),sym(0),sym(inf),nodes)
  eval(subs(rest_f,theta,1))
endfunction
