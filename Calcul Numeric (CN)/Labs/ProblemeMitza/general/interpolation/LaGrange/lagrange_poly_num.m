function lmf=lagrange_poly_num(x,y,XV)
  #x -> coordonatele x
  #y -> coordonatele y
  #XV -> valorile in care se doreste polimomul
  m=length(x);
  basis_polys=lagrange_basis_num(x,XV);
  lmf=y*basis_polys;
endfunction
