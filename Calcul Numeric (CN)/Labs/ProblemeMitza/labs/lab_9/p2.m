function p2()
  x=zeros(1,10);
  y=zeros(1,10);
  x(1:5)=[1.024940,0.949898,0.866114,0.773392,0.671372];
  x(6:10)=[0.559524,0.437067,0.302909,0.159493,0.007464];
  x=-x;
  y(1:5)=[0.389269,0.322894,0.265256,0.216557,0.177152];
  y(6:10)=[0.147582,0.128618,0.121353,0.127348,0.148895];
  y=-y;

  b=(x.^2)';
  A=[(y.^2)',(x.*y)',x',y',ones(10,1)];
  [coefs1,err1]=solveQR(A,b)

  b=(x.^2)';
  A=[y',ones(10,1)];
  [coefs2,err2]=solveQR(A,b)

  if err1<err2
    disp("First method is better");
  elseif err2<err1
    disp("Second method is better");
  else
    disp("Both methods have the same error");
  endif
endfunction
