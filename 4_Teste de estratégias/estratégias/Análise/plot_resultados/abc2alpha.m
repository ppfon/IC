function alfa_beta = abc2alpha(Vabc)

k_clarke = 2/3

matriz_clarke = [ 1 -0.5 -0.5 ;
    0 sqrt(3)/2 -sqrt(3)/2;
    0.5 0.5 0.5;
    ];

alfa_beta = k_clarke * matriz_clarke * Vabc;