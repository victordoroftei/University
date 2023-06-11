f=@(x) exp(-x.^2);
a=-1;
b=1;
err=eps;

disp("Actual");
integral(f,a,b)
disp("Adaptiv Simpson");
adapt_quad_simpson(f,a,b,err)
