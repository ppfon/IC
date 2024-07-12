function [amp,fase, freq] = calcula_espectro(amp_sinal, periodo, pu)
    freq_amostragem = 1/periodo;
    num_pontos = length(amp_sinal);

    Y = abs(fft(amp_sinal, num_pontos))/num_pontos;

    espectro = Y(1:num_pontos/2+1);
    espectro(2:end-1) = 2*espectro(2:end-1);
    
   if (pu) 
        amp = espectro/espectro(1);
   else
        amp = espectro; 
   end
   
    fase = angle(espectro);
    freq = freq_amostragem/num_pontos*(0:(num_pontos/2));
end