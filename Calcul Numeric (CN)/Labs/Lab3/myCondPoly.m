function nc=myCondPoly(p,xi)
%CONDPOL - condition of the root of an algebraic equation
%call NC=CONDPOL(P,XI)

if nargin<2
    disp("Calculating roots");
    xi=roots(p);
end
disp("Original polynom");
polyout(p, 'x');
dp=polyder(p); %derivative;
disp("Derivate polynom");
polyout(dp, 'x');
disp("Conditional numbers for each root")
condNumbers=1./(abs(xi.*polyval(dp,xi))).*(polyval(abs(p(2:end)),abs(xi)));
n = length(p) - 1;
nc = [];
for i=1:n
  nc = [nc; [condNumbers(i)(1) xi(i)]];
endfor
