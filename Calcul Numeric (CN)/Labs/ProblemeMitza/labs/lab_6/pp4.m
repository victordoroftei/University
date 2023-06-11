function pp4()
  a=-5;
  b=5;
  f=@(x) 1./(1+x.^2);
  #a=-1;
  #b=1;
  #f=@(x) abs(x);

  pp4_draw(f,a,b);
endfunction
