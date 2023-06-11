function p2()
  a=-pi;
  b=pi;
  f=@(t) sin(t);
  fd=@(t) cos(t);

  p2_draw(f,fd,a,b);
endfunction
