function pp3()
  X=10;

  x=[0,3,5,8,13];
  y=[0,225,383,623,993];
  dy=[75,77,80,74,72];

  [H,DH]=interpolationHermit(x,y,dy,X)
endfunction
