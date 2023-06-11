# a) w=exp(-x), a=0, b=+inf, n=3 noduri
syms x
w=exp(-x);a=sym(0);b=sym(inf);n=3; #n= nr. nodes
# step 0: x1=a=0 nod fixat. Trebuie sa aplicam o metoda Gauss-Radau
# step 1: aflam wa
wa=(x-a)*w;
# step 2: aflam polinomul de grad n-1 din setul de polinoame ortgonale
# in raport cu wa pe [0;+inf). observam ca este polinom Laguerre
# cu afla=1
pin=orto_poly_sym_type('Laguerre',n-1,sym(1));
# step 3: aflam restul de n-1 noduri ca fiind radacinile polinomului aflat
sols=solve(pin,x)';
nodes=[a sols]
# step 4: aflam coeficientii
coefs=gauss_coefs_sym(w,a,b,nodes)
# step 5: aflam restul. theta semnifica f derivat de 2*n-1=5 ori in xi, xi din
# [0;+inf).
syms theta
rest=gauss_rest_sym(w,a,b,sols,1,0,x,theta)
# b) log(1+exp(-x))=log(1+exp(-x))*exp(x)*exp(-x) => f(x)=log(1+exp(-x))*exp(x)
f=@(x) log(1+exp(-x)).*exp(x);
# pentru rest trebuie sa aflam theta, adica valoarea absoluta a derivatei de
# ordin 2*n-1 care este maxima pe [-1;1]
f_der=sym(f);f_der=simplify(diff(f_der,2*n-1)-f)+f; # x=[0;+infinit)
f_der=subs(f_der,exp(x),1/x); abs_f_der=function_handle(abs(f_der));#x=(0;1]
clf;fplot(abs_f_der,[0,1]);
IG=eval(coefs*f(nodes)')
eroare_max=abs(eval(subs(rest,theta,1))*0.1)
IO1=integral(@(x) log(1+exp(-x)),eval(a),eval(b))
IO2=quad(@(x) log(1+exp(-x)),eval(a),eval(b))

