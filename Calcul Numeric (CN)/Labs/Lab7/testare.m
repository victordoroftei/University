timpi=[0 3 5 8 13];
distante=[0  225  383  623  993];
viteze=[75  77   80   74   72];

X = [10 11 12 13];

[H_vec, DH_vec] = hermite_vectorized(timpi, distante, viteze, X)

