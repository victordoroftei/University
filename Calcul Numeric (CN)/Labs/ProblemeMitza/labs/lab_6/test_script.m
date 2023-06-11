syms X
f=@(t) t.^2-3;
x=[-3 1 4];
y=f(x); #[6 -2 13]
lmf=lagrange_poly_sym(x,y,X);

lmf=simplify(lmf)
all(double(subs(lmf,x))==y)
