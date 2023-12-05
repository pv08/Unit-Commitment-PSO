%% Comparação de Custo Por Cenário

global UTE 

G1 = [0];
G2 = [0];
G3 = [140];
G4 = [140];

M=[G1^2 G1 (G1~=0);
 G2^2 G2 (G2~=0);  
 G3^2 G3 (G3~=0);
 G4^2 G4 (G4~=0)];

xxx=sum((M.*[UTE(:,3) UTE(:,2) UTE(:,1)])')'

sum(xxx)
