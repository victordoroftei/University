function p2()
  f=@(x) cos(x);
  a=0;
  b=2*pi;
  n=10;
  method="dreptunghi";

  clf; hold on;
  fplot(f,[a,b],"k","linewidth",3);
  draw_rep_method(f,a,b,n,method)
  axis([a,b]);
endfunction
