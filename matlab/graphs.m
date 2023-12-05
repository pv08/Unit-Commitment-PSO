%% Algorcounttmo de plotagem
global PSO HORA P UTE
tamanho = length(f.xval)/(2*length(HORA(:,1)));

a = [UTE(1:P-1,1);UTE(P+1:end,1)];
b = [UTE(1:P-1,2);UTE(P+1:end,2)];
c = [UTE(1:P-1,3);UTE(P+1:end,3)];

Pgmax = [UTE(1:P-1,4);UTE(P+1:end,4)];

NT = length(Pgmax);
P_lot=[];
PSW=[];
for count = 1 : length(HORA(:,1))
    rg = HORA(count,2);
    demanda = HORA(count,1);
    
    GER = f.xval(1 + (count-1)*NT : NT + (count-1)*NT );
    U = f.xval(1 + (count-1)*NT +PSO.d/2 : NT + (count-1)*NT+ PSO.d/2);
    
    PSW = demanda - U*GER';
    
    if P ~= 0
        P_lot = [P_lot;U(1:P-1).*GER(1:P-1) PSW U(P:end).*GER(P:end)];
    else
        P_lot = [P_lot;U.*GER];
    end
    
    %% Plotagem de custo por hora
    
    Ccen.custo(count) = U*(c.*(GER.^2)' + b.*(GER)' + a)+PSW^2*UTE(P,3)+PSW*UTE(P,2)+UTE(P,1);

    
end



figure(1)
bar(P_lot,'stacked')
xlabel('Hora')
ylabel('Potência Gerada (MW)')
legend('G1','G2','G3','G4')
title('Participação de UTE por Hora')
axis([0 length(HORA(:,1))+1 0 1.1*max(max(HORA(:,1)))])
pause(0.3)









