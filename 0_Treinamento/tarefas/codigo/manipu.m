rho = ro{:,2};
tempo = ro{:,1};

A = gradient(rho{:})/gradient(tempo{:});

