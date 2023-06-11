function T=draw_sym_function(f_sym,a,b)
  fh=function_handle(f_sym);
  fplot(fh,[a,b]);
endfunction
