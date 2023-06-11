function pp3()
  f=@(t) sqrt(t);

  a=0;
  b=230;
  m=100;
  type='Cebisev1';
  x=generate_nodes(a,b,m,type);
  y=f(x);
  X=115;

  [cal,nr_steps]=lagrange_aitken(x,y,X,1e-3);
  disp("Calculated");
  cal
  disp("Correct");
  cor=f(X)
  disp("Absolute error");
  abs_err=abs(cor-cal)
  disp("Relative error");
  rel_err=abs_err/abs(cor)
  disp("Nr. steps");
  nr_steps
endfunction
