# a) w=sqrt(1+x), a=-1, b=1, n=3 noduri
syms x
w=sqrt(1+x);a=sym(-1);b=sym(1);n=3; #n= nr. nodes
# step 0: x3=b=1 nod fixat. Trebuie sa aplicam o metoda Gauss-Radau
# step 1: aflam wa
wa=(b-x)*w
# step 2: aflam polinomul de grad n-1 din setul de polinoame ortgonale
# in raport cu wa pe [-1;1]. observam ca este polinom Jacobi
# cu afla=1,beta=1/2
pin=orto_poly_sym_type('Jacobi',n-1,sym(1),sym(1)/2);
# step 3: aflam restul de n-1 noduri ca fiind radacinile polinomului aflat
sols=solve(pin,x)';
nodes=[sols,b]
# step 4: aflam coeficientii
coefs=gauss_coefs_sym(w,a,b,nodes)
# step 5: aflam restul. theta semnifica f derivat de 2*n-1=5 ori in xi, xi din
# [-1;1].
syms theta
rest=gauss_rest_sym(w,a,b,sols,0,1,x,theta)
# b) f(x)=cos(x) => f derivat de 4 ori e tot cos(x) => abs(f derivat de 5 ori
# (x)) = |sin(x)|. maximul este 1.
IG=eval(coefs*f(nodes)')
eroare_max=abs(eval(subs(rest,theta,1))*1)
IO1=integral(@(x) sqrt(1+x).*cos(x),eval(a),eval(b))
IO2=quad(@(x) sqrt(1+x).*cos(x),eval(a),eval(b))

