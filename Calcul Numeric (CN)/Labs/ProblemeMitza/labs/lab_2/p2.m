function p2()
  x=10*pi;
  digits=1144;

  disp("Basic");
  disp("cos");
  cosred(x)
  disp("sin");
  sinred(x)

  disp("Better");
  disp("cos");
  mycos(x,digits)
  disp("sin");
  mysin(x,digits)
endfunction
