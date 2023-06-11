function [L, U, P]=lup_decomposition(A)
  [m, n] = size(A);
  P = zeros(m, n);
  piv = (1:m)';
  for i=1:m-1
    [pivot, pivotIndex] = max(abs(A(i:end, i)));
    pivot = A(i+pivotIndex-1, i); % since the above operation is in module, we have
    % to take the true value of the max(with the correct sign)
    % printf("%d -> %d\n", pivot, pivotIndex);
    lineIndex = i + pivotIndex - 1;
    if lineIndex != i
      otherLineIndex = i;
      A([otherLineIndex, lineIndex], :) = A([lineIndex, otherLineIndex], :);
      piv([otherLineIndex, lineIndex]) = piv([lineIndex, otherLineIndex]);
    endif
    A(i+1:end, i) /= pivot;
    % Schur complement
    A(i+1:end, i) * A(i, i+1:end);
    A(i+1:end, i+1:end) -= A(i+1:end, i) * A(i, i+1:end);
  endfor
  for i=1:m
    P(i, piv(i)) = 1;
  endfor
  U = triu(A);
  L = tril(A, -1) + eye(m);
endfunction
