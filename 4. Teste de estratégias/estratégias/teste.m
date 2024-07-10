freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;

le_baixo = load("900\apoc\ativo\base.mat", "base");
baixo = le_baixo.base;

le_alto = load("9k\apoc\ativo\base.mat", "base");
alto = le_alto.base;

tempo_alto = (alto(:,1)-alto(1))*periodo_amostragem;
amplitude_alto = alto(:,2);

tempo_baixo = (baixo(:,1)-baixo(1))*(periodo_amostragem*10);
amplitude_baixo = baixo(:,2);

figure(1);
[amp, fase, freq] = plota_espectro(amplitude_alto, periodo_amostragem, 1);
plot(freq, amp, 'g'); hold on;

[amp, fase, freq] = plota_espectro(amplitude_baixo, periodo_amostragem*10, 1);
plot(freq, amp, 'r');