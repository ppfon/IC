switch estrategia
    case 'aarc'
        kp = 1; kq = 1;
        P_ref = [2000; 0; 1000];
        y_ponto_ativo = [1190.37; 55.0847; 0];

        Q_ref = [0; 2000; 1000];
        y_ponto_reativo = [66.3281; 1413.83; 0];
        
    case 'bpsc'
        kp = 0; kq = 0;

        P_ref = [2000; 0; 1500];
        y_ponto_ativo = [639.309; 798.983; 0];

        Q_ref = [0; 2000; 1500];
        y_ponto_reativo = [636.601; 809.007; 0];

    case 'pnsc'
        kp = -1; kq = -1;
        P_ref = [2000; 0; 1000];
        y_ponto_ativo = [20.0432; 1778.94; 0];

        Q_ref = [0; 2000; 1000];
        y_ponto_reativo = [1350.95; 246.058; 0];
    
    case 'apoc'
        kp = -1; kq = 1;
        
        P_ref = [2000; 1000; 1500];
        Q_ref = [1000; 1000; 1500];
        % u = 1/3
        % y_ponto_ativo = [21.8017; 0; 0];
        % y_ponto_reativo = [1437.64; 0; 0];
        
        % u = 0.181818181818182
        y_ponto_ativo = [17.2851; 0; 0];
        y_ponto_reativo = [750.105; 0; 0];
    
    case 'rpoc'
        kp = 1; kq = -1;
        
        P_ref = [2000; 1000; 500];
        Q_ref = [1000; 2000; 500];
        
        % u = 1/3
        % y_ponto_ativo = [1455.63; 0; 0];
        % y_ponto_reativo = [74.738; 0; 0];
        
        % u = 0.181818181818182
        y_ponto_ativo = [810.754; 0; 0];
        y_ponto_reativo = [50.5614; 0; 0];
        
    otherwise
        error('Estratégia desconhecida.');
end