function x = gausselim(A, b)

  A = [A b];  # lipim coloana b la A
  n = length(b);

  for k = 1:n - 1

    # pivot, cautat in zona verde, maximul modulului elementelor din zona verde
    [valmax, pozmax] = max(abs(A(k:end, k)));
    pozpivot = pozmax + k - 1;  # adaugam k - 1 pt ca incepem numerotarea de la 1, care e de fapt k

    if valmax == 0

      disp("NU avem solutie unica");
      return;

    elseif pozpivot != k

       A([k, pozpivot], k:end) = A([pozpivot, k], k:end);

    endif

    for i = k + 1:n

      A(i, k:end) = A(i, k:end) - A(k, k:end) * (A(i, k) / A(k, k));

    endfor

  endfor

  x = backwardsubs(A(:,1:n), A(:, n + 1));

endfunction
