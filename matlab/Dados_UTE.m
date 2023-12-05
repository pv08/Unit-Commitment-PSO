%% DADOS DO SISTEMA

global UTE HORA

%       a      b      c     PGmáx  PGmin  Umax   Umin
UTE = [1000  16.19 0.00048   455    150     1      0;
       0970  17.26 0.00031   455    150     1      0;
       0700  16.60 0.00200   130    020     1      0;
       0680  16.50 0.00211   130    020     1      0];
   
   
%      DEMANDA(MW)   RESERVA(MW)   
HORA = [   450          45;
           530          53;
           600          60;
           540          54;
           400          40;
           280          28;
           290          29;
           500          50]; 
       
% HORA(:,1)=  1.4*HORA(:,1);     
       
