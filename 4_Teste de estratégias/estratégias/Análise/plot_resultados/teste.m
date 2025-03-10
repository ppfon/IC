%pi = vpa(pi,100);
% Tensões de fase (em pu)
deseq = 0.6;
Va = 220*sqrt(2)/sqrt(3);
Vb = Va*deseq*exp(1j*120*pi/180); % Assumindo um ângulo de 120 graus para Vb
Vc = Va*deseq*exp(-1j*120*pi/180); % Assumindo um ângulo de -120 graus para Vc

% Matriz de transformação de sequência
a = exp(1j*120*pi/180);
A = 1/3*[1 1 1; 1 a^2 a; 1 a a^2];

% Componentes de sequência
Vseq = A*[Va; Vb; Vc];

% Fator de desbalanço
v_neg = abs(Vseq(1)); v_pos = abs(Vseq(2));
u = abs(Vseq(1))/abs(Vseq(2));