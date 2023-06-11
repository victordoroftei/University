function p5()
  a=-pi;
  b=pi;
  m=8;
  type='Cebisev1';
  x=generate_nodes(a,b,m,type);
  f=@(t) sin(t);
  X=pi/2;

  disp("Aproximated");
  lagrange_bary(x,f(x),X,type)
  disp("Actual");
  f(X)
endfunction
