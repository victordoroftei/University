function p3()
  a=-pi;
  b=pi;
  m=5;
  type='Cebisev1';
  x=generate_nodes(a,b,m,type);
  f=@(t) sin(t);

  p3_draw(f,x,a,b)
endfunction
