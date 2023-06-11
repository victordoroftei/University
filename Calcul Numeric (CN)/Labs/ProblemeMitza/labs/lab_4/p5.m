function p5()
  n=5;
  mat_size=n+1;
  #solutia sistemului e ones(mat_size,1)

  A=(-1)*ones(mat_size);
  A=tril(A,-1)+eye(mat_size);
  for k=1:mat_size
    A(k,mat_size)=1;
  endfor

  b=zeros(mat_size,1);
  b(1)=2;
  for k=2:mat_size
    b(k)=b(k-1)-1;
  endfor
  b(mat_size)=b(mat_size)-1;

  disp("LUP | QR | difference");
  [solveLUP(A,b) solveQR(A,b) abs(solveLUP(A,b)-solveQR(A,b))]
endfunction
