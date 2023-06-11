function sol=my_gauss(A)
  n = length(A)-1;
  for i=1:n
    [pivot, pivotIndex] = max(abs(A(i:end, i)));
    pivot = A(i + pivotIndex -1, i); % since the above operation is in module, we have
    %to take the true value of the max(with the correct sign)
    %printf("%d -> %d\n", pivot, pivotIndex);
    lineIndex = i + pivotIndex - 1;
    if lineIndex != i
      otherLineIndex = i;
      A([otherLineIndex, lineIndex], :) = A([lineIndex, otherLineIndex], :);
    endif
    A(i+1:end, i) /= pivot;
    for j=i+1:n
      A(j, :) += (-1) * A(j, i) * A(i, :);
    endfor
    A(i+1:end, i) = 0;
  endfor
  sol = [A(n, n+1) / A(n, n)];
  for i=n-1:-1:1
    xi = (A(i, n+1) - sum(A(i, i+1:n) .* (sol))) / A(i, i);
    sol = [xi sol];
  endfor
endfunction
