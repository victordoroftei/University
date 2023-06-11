function draw_rep_method(f,a,b,n,method)
  h=(b-a)/n;
  switch method
    case "dreptunghi"
      for i=1:n
        x_int=[a+(i-1)*h,a+i*h];
        x_mij=x_int(1)+h/2;
        x_space=linspace(x_int(1),x_int(2));
        y_space=f(x_mij)*ones(1,length(x_space));
        area(x_space,y_space);
      endfor
    case "trapez"
      for i=1:n
        x_int=[a+(i-1)*h,a+i*h];
        fk=@(x) lagrange_bary(x_int,f(x_int),x);
        x_space=linspace(x_int(1),x_int(2));
        area(x_space,fk(x_space));
      endfor
    case "simpson"
      for i=1:n
        x_int=[a+(i-1)*h,a+(i-1/2)*h,a+i*h];
        fk=@(x) lagrange_bary(x_int,f(x_int),x);
        x_space=linspace(x_int(1),x_int(3));
        area(x_space,fk(x_space));
      endfor
  endswitch
endfunction
