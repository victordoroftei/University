function ps1()
  f=@(x) cos(x);
  x=linspace(0,2*pi,3);
  y=f(x);
  xv=linspace(0,2*pi,6);
  yv=f(xv);
  xw=linspace(0,2*pi,1000);
  yw=f(xw);

  disp("Coefs");
  getSplineCubicCoefs(x,y,'periodice',[])

  disp("Comparation");
  sv=getSplineCubicEval(x,y,'periodice',[],xv);
  diffv=abs(yv-sv);
  [xv' yv' sv' diffv']

  disp("Computing Overall Relative Error:");
  sw=getSplineCubicEval(x,y,'periodice',[],xw);
  norm(yw-sw)/norm(yw)
endfunction
