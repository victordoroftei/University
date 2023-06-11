function p0_a()
  A=[10 7 8 7; 7 5 6 5; 8 6 10 9; 7 5 9 10];
  b=[32 23 33 31]';
  x=A\b

  bp=[32.1 22.9 33.1 30.9]';
  xp=A\bp
endfunction
