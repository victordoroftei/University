function pp2()
  #puteti folosi valorile din tabele, dar dupa nu se respecta
  #delimitarea erorii
  X=0.34;
  val=sin(X);

  disp("Actual");
  val

  x=[0.30,0.32,0.35];
  #y=[0.29552,0.31457,0.34290];
  #dy=[0.95534,0.94924,0.93937];
  y=sin(x);
  dy=cos(x);

  #avem 3 puncte, deci vrem a 3-a derivata a lui sin -> -cos
  #|-cos| e descrescatoare pe [0;1], deci maximul se atinge in 0.30
  disp("Delimitation");
  abs(interpolation_rest(x,X,cos(0.30)))
  #interpolation_rest_fun(@(x) sin(x),x,X)

  disp("First");
  valH=interpolationHermit(x,y,dy,X)
  disp("First absolute error");
  abs(valH-val)
  disp("First relative error");
  abs(valH-val)/abs(val)

  x=[0.30,0.32,0.33,0.35];
  #y=[0.29552,0.31457,sin(0.33),0.34290];
  #dy=[0.95534,0.94924,cos(0.33),0.93937];
  y=sin(x);
  dy=cos(x);

  disp("Second");
  valH=interpolationHermit(x,y,dy,X)
  disp("Second absolute error");
  abs(valH-val)
  disp("Second relative error");
  abs(valH-val)/abs(val)
endfunction
