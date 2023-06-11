function l = lab3(coefs)

  # |dy| / |dx| <= cond f(x)
  # |dy| = |delta y| / |y|
  # |dx| = |delta x| / |x|
  # => |dy| / |dx| = (|delta y| / |delta x|) * (|x| / |y|)
  # delta y = errel(y, yp)
  # delta x = errel(x, xp)

  x = 10;
  xp = 10.5;

  y = polyval(coefs, x);
  yp = polyval(coefs, xp);

  delta_x = errel(x, xp);
  delta_y = errel(y, yp);

  delta = (abs(delta_y) / abs(delta_x)) * (abs(x) / abs(y));
  nr_cond = condpol(coefs, 3);

  disp("Delta: ");
  disp(delta);

  disp("\nNr. cond.: ");
  disp(nr_cond);

endfunction
