function coefs=gauss_coefs_sym(w,a,b,nodes,x)
  # x este simbolul lui w
  # calculeaza A1,A2,...,An pentru Gauss in int de la a la b din w*f

  if nargin<5
    syms x
  endif
  coefs=sym([]);
  n=length(nodes);
  for k=1:n
    integral_val=int(prod(x-nodes([1:k-1,k+1:n]))*w,x,a,b);
    prod_val=prod(nodes(k)-nodes([1:k-1,k+1:n]));
    coefs(k)=simplify(integral_val/prod_val);
  endfor
endfunction
