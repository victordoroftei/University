function ps1()
  f=@(x) x.^5-1;
  df=@(x) 5*x.^4;
  ddf=@(x) 20*x.^3;
  dddf=@(x) 60*x.^2;

  x=[-1,0,2];
  r=[4,1,2];
  vals={};
  vals(1)=f(x);
  vals(2)=df(x);
  vals(3)=ddf(x);
  vals(4)=dddf(x);

  interpolationDifDivGen(x,r,vals)
  res=interpolationHermitGen(x,r,vals,x,r)


  syms X
  H=interpolationHermitGen(x,r,vals,X,4);
  simplify(H{1})
endfunction
