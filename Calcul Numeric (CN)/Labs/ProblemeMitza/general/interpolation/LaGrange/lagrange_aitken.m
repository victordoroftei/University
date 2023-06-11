function [LXV,nrStepsV]=lagrange_aitken(x,y,XV,errV=zeros(1,length(XV)))
  #nrStepsV -> nr. de elemente din tabel ce au fost calculate
  #(mai putin prima coloana)
  #iterarea se face pe linii - mai eficient ca flops
  LXV=XV;
  nrStepsV=zeros(1,length(XV));
  m=length(x);
  for k=1:length(XV)
    X=XV(k);
    err=errV(k);

    [values,orders]=sort(abs(X-x));
    x=x(orders);#acum x sunt sortati crescator dupa distantele fata de X
    y=y(orders);

    diag_vals=zeros(1,m);
    current=zeros(1,m);
    #i=1
    diag_vals(1)=y(1);
    current(1)=y(1);
    LX=y(1);
    nrSteps=0;
    #i=2:m
    for i=2:m
      current(1)=y(i);
      for j=1:i-1
        current(j+1)=diag_vals(j)*(x(i)-X)-current(j)*(x(j)-X);
        current(j+1)=current(j+1)/(x(i)-x(j));
      endfor
      diag_vals(i)=current(i);

      oldV=LX;
      LX=diag_vals(i);
      nrSteps+=i-1;
      if abs(LX-oldV)<err
        break;
      endif
    endfor

    LXV(k)=LX;
    nrStepsV(k)=nrSteps;
  endfor
endfunction
