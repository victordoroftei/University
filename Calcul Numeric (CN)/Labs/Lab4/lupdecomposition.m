function [L, U, P] = lupdecomposition(A)

  # LUP - LUP decomposition of A
  # Permute effecively lines

  [m, n] = size(A);
  P = zeros(m, n);
  piv = (1:m)';

  for i = 1:m - 1

    # Pivoting
    [pivot, pivotIndex] = max(abs(A(i:m, i)));
    pivotIndex = pivotIndex + i - 1; # Adaugam k - 1 pt ca incepem numerotarea de la 1, care e de fapt k

    # Line interchange
    if i != pivotIndex

      A([i, pivotIndex], :) = A([pivotIndex, i], :);
      piv([i, pivotIndex]) = piv([pivotIndex, i]);

    endif

    # Schur complement
    lin = i + 1:m;
    A(lin, i) = A(lin, i) / A(i, i);
    A(lin, lin) -= A(lin, i) * A(i, lin);

  endfor

  for i = 1:m

    P(i, piv(i)) = 1;

  endfor

  U = triu(A);
  L = tril(A, -1) + eye(m);

endfunction
