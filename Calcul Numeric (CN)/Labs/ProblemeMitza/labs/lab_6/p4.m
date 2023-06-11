function p4()
  a=-pi;
  b=pi;
  m=8;
  type='Cebisev1';
  x=generate_nodes(a,b,m,type);
  f=@(t) sin(t);
  X=pi/2;

  lmf=lagrange_poly_num(x,f(x),X);
  disp("Aproximated");
  lmf
  disp("Actual");
  f(X)
endfunction
