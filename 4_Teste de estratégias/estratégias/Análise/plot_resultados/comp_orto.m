function componentes = comp_orto(Vabc)

k = 1/sqrt(3);

    matriz_comp_orto = [  0   1   -1 ;
    -1   0 1 ;
    1 -1 0 ;
    ];

    componentes = k * matriz_comp_orto * Vabc;