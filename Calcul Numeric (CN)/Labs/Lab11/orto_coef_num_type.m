function [alpha,beta]=orto_coef_num_type(type,k,aa=[],bb=[])
  n=length(k);
  alpha=zeros(1,n); beta=[];
  switch type
  case 'Legendre'
    for i=1:n
      if k(i)==0
        beta(i)=2;
      else
        beta(i)=1/(4-k(i).^-2);
      endif
    endfor
  case 'Cebisev1'
    for i=1:n
      if k(i)==0
        beta(i)=pi;
      elseif k(i)==1
        beta(i)=1/2;
      else
        beta(i)=1/4;
      endif
    endfor
  case 'Cebisev2'
    for i=1:n
      if k(i)==0
        beta(i)=pi/2;
      else
        beta(i)=1/4;
      endif
    endfor
  case 'Jacobi'
    for i=1:n
      if k(i)==0
        alpha(i)=(bb-aa)/(aa+bb+2);
        beta(i)=2^(aa+bb+1)*gamma(aa+1)*gamma(bb+1)/gamma(aa+bb+2);
      else
        alpha(i)=(bb^2-aa^2)/((2*k(i)+aa+bb)*(2*k(i)+aa+bb+2));
        if k(i)==1&&aa+bb+1==0
         beta(i)=4*(aa+1)*(bb+1)/2;
        else
         beta(i)=4*k(i)*(k(i)+aa)*(k(i)+bb)*(k(i)+aa+bb)/ ...
         ((2*k(i)+aa+bb)^2*(2*k(i)+aa+bb+1)*(2*k(i)+aa+bb-1));
        endif
      endif
    endfor
  case 'Laguerre'
    for i=1:n
      alpha(i)=2*k(i)+aa+1;
      if k(i)==0
        beta(i)=gamma(1+aa);
      else
        beta(i)=k(i)*(k(i)+aa);
      endif
    endfor
  case 'Hermite'
    for i=1:n
      if k(i)==0
        beta(i)=sqrt(pi);
      else
        beta(i)=k(i)/2;
      endif
    endfor
  endswitch
endfunction
