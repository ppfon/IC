% Tensões de fase (em pu)
Va = 1;
Vb = 0.6*exp(1j*120*pi/180); % Assumindo um ângulo de 120 graus para Vb
Vc = 0.6*exp(-1j*120*pi/180); % Assumindo um ângulo de -120 graus para Vc

% Matriz de transformação de sequência
a = exp(1j*120*pi/180);
A = 1/3*[1 1 1; 1 a^2 a; 1 a a^2];

% Componentes de sequência
Vseq = A*[Va; Vb; Vc];

% Fator de desbalanço
u = abs(Vseq(1))/abs(Vseq(2));

deseq = [0.5714 25.404; 0.33 50.8; 0.1818 76.2120];