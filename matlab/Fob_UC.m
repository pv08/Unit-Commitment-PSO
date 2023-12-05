%% Função Objetivo UNIT COMMITMENT
function [C]=Fob_UC(x)

global HORA UTE PSO P 

%% Vetor de solução

%      |          HORA 1                |      ...     |       HORA M      
% x = [ G1, G2, ..., Gn, U1, U2, ...,Un , ............  G1, G2, ..., Gn, U1, U2, ...,Un ]


Ni = 10^15; % Constante de penalização da FOB
C = 0;      % Custo total do sistema
Bin = 0;    % Variável Binária

a = [UTE(1:P-1,1);UTE(P+1:end,1)];
b = [UTE(1:P-1,2);UTE(P+1:end,2)];
c = [UTE(1:P-1,3);UTE(P+1:end,3)];

Pgmax = [UTE(1:P-1,4);UTE(P+1:end,4)];

NT = length(Pgmax);
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
 
  
    %% Cálculo da FOB
        if P ~= 0
            Ccen = U*(c.*(GER.^2)' + b.*(GER)' + a)+ PSW^2*UTE(P,3)+PSW*UTE(P,2)+UTE(P,1); % Custo do cenário H
        else 
            Ccen = U*(c.*(GER.^2)' + b.*(GER)' + a);
        end
    
    
    C = C + Ccen ;
end

% Minimização: Quando um limite é violado a FOB é penalizada
C = (C + Bin*Ni);


end