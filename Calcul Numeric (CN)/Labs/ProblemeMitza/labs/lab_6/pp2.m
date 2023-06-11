function pp2()
  f=@(t) exp(t.^2-1);

  a=1;
  b=1.4;
  m=5;
  type='echidistante';
  x=generate_nodes(a,b,m,type);
  y=f(x);
  X=1.25;

  disp("Calculated");
  cal=lagrange_bary(x,y,X,type)
  disp("Correct");
  cor=f(X)
  #Pentru delimitarea erorii, daca facem a 5-a derivata a lui f, observam
  #ca f este strict crescatoare pe [1;2], deci M=df(1.4), unde df e a 5-a
  #derivata. De aici, doar se aplica formula pentru rest
  df=sym(f);
  for k=1:m
    df=diff(df);
  endfor
  df=function_handle(df);
  disp("Delimitation");
  interpolation_rest(x,X,df(b))

  disp("Absolute error");
  abs_err=abs(cor-cal)
  disp("Relative error");
  rel_err=abs_err/abs(cor)
endfunction
