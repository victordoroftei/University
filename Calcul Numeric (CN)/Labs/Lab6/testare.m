x = [1 2 3 4];
f = [2 7 12 17]; # f(x) = 5x - 3
xsym = sym('X');

LX = lagrange_classic(x, f)

xtest = 10;
subs(LX, xsym, xtest)
