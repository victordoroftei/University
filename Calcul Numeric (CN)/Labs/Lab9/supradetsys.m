function [c, eroare] = supradetsys(A, f)

  [Q, R] = qr(A);
  [n, m] = size(A);

  b = Q' * f; # Q' = Q transpus
  c = R(1:m, :) \ b(1:m);

  eroare = norm(b(m + 1:n));

endfunction
