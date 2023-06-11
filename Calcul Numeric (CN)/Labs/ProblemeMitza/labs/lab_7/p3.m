function p3()
  f=@(x) x.^2;
  df=@(x) 2*x;

  a=-5;
  b=5;
  x=[-2,3,4];
  y=f(x);
  dy=df(x);

  p3_draw(x,y,dy,a,b);
endfunction
