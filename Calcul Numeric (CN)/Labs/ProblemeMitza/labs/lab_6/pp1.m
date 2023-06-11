function pp1()
  a=1900;
  b=2010;
  m=12;
  type='echidistante';
  x=generate_nodes(a,b,m,type);
  y=[75.995,91.972,105.711,123.203,131.669,150.697,179.323,203.212,226.505];
  y=[y,249.633,281.422,308.786];

  disp("1975:");
  lagrange_bary(x,y,1975,type)
  disp("2018:");
  lagrange_bary(x,y,2018,type)
endfunction
