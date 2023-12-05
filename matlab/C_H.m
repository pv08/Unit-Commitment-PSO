%% Função de Cálculo de Custo por Hora

function [Cost]=C_H(x)

global HORA UTE  P PSO
a = [UTE(1:P-1,1);UTE(P+1:end,1)];
b = [UTE(1:P-1,2);UTE(P+1:end,2)];
c = [UTE(1:P-1,3);UTE(P+1:end,3)];

Pgmax = [UTE(1:P-1,4);UTE(P+1:end,4)];

NT = length(Pgmax);

P_lot = [];
for i = 1 : length(HORA(:,1))
    
    % Reserva e Carga
    rg = HORA(i,2);
    demanda = HORA(i,1);
    
    GER = x(1 + (i-1)*NT : NT + (i-1)*NT );
    U = x(1 + (i-1)*NT +PSO.d/2 : NT + (i-1)*NT+ PSO.d/2);
    
    
    %% Atendimento das Restrições de Igualdade
    if P == 0
        PmaxSW = 0;
        PSW = 0;
        if U*GER' ~= demanda;
            Bin = 1;
        end
    else
    %% Balanço de Potência com barra swing  
        PmaxSW = UTE(P,4);
        PminSW = UTE(P,5);
        PSW = demanda - U*GER';
        
        if PSW > PmaxSW || PSW < PminSW
            Bin = 1;
        end
    end
    
    %% Atendimento das Restrições de Desigualdade  
    if (U*Pgmax + PmaxSW) < rg + demanda;
        Bin = 1;
    end
   
    if P ~= 0
        vger=[U(1:P-1).*GER(1:P-1) PSW U(P:end).*GER(P:end)];

        von=[U(1:P-1) 1 U(P:end)];
        
        vcost = vger.^2.*UTE(:,3)'+vger.*UTE(:,2)'+von.*UTE(:,1)';
        P_lot = [P_lot;vcost];
    else
        P_lot = [P_lot;U.*GER];
    end
    
    
 
    
    
    %% Cálculo da FOB
    
    Ccen = U*(c.*(GER.^2)' + b.*(GER)' + a)+PSW^2*UTE(P,3)+PSW*UTE(P,2)+UTE(P,1); % Custo do cenário H
    Cost.Cenario(i,1)=Ccen;
end
Cost.plot=P_lot;
end