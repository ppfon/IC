function [amp_pu, fase, freq] = calcula_espectro(amp_sinal, periodo, pu)
    % Frequência de amostragem
    freq_amostragem = 1 / periodo;
    % Número de pontos no sinal
    num_pontos = length(amp_sinal);
    
    % Cálculo da FFT e normalização
    Y = fft(amp_sinal, num_pontos);
    Y = abs(Y)/num_pontos;
    
    % Apenas a primeira metade do espectro (simétrica para FFT real)
    espectro = Y(1:num_pontos/2+1);
    espectro(2:end-1) = 2*espectro(2:end-1);

    % Frequências correspondentes
    freq = freq_amostragem / num_pontos * (0:(num_pontos/2));
    
    % Potência de cada componente individual (amplitude ao quadrado)
    P_k = espectro.^2;
    
    % Potência total (incluindo DC)
    P_total = sum(P_k);
    
    % Normalização em per-unit
    if (pu == 1)
        amp_pu = P_k/ P_total;  % Potência de cada componente em pu
    elseif (pu == 2) 
        amp_pu = espectro/espectro(1); % normalizado pela componente DC
    else
        amp_pu = espectro;       % Amplitude normal
    end
    
    % Fase do espectro
    fase = angle(Y(1:num_pontos/2+1));
end
