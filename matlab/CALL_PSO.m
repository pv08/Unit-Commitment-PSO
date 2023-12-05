%% CHAMA FUNÇÃO PSO
% Victor Ferreira Carvalho
% 26/11/2023
%%
clear all
close all
clc
tic
%%
global PSO UTE HORA P 
format short
%% Dados do Sistema
Dados_UTE;  
HigherCost
% P=0;
%% Inicialização PSO
Pgmin = [UTE(1:P-1,5)' UTE(P+1:end,5)'];
Pgmax = [UTE(1:P-1,4)' UTE(P+1:end,4)'];

UCmin = [UTE(1:P-1,7)' UTE(P+1:end,7)'];
UCmax = [UTE(1:P-1,6)' UTE(P+1:end,6)'];


% Dimensão do PSO (HORAS x PG+UC)
PSO.d = 2*length(Pgmin)*length(HORA(:,1));      

% Limites das variáveis
PSO.xbound.xminGer = [];    % XminGeração
PSO.xbound.xmaxGer  = [];   % XmaxGeração
PSO.xbound.xminUC = [];     % XminUC
PSO.xbound.xmaxUC  = [];    % XmaxUC

for i = 1 : length(HORA(:,1))
    PSO.xbound.xminGer  = [PSO.xbound.xminGer,Pgmin];   % Xmin Geração
    PSO.xbound.xminUC   = [PSO.xbound.xminUC,UCmin];    % Xmin UC  
    
    PSO.xbound.xmaxGer  = [PSO.xbound.xmaxGer,Pgmax];   % Xmax Geração
    PSO.xbound.xmaxUC   = [PSO.xbound.xmaxUC,UCmax];    % Xmax UC 
end

PSO.xbound.xmin = [PSO.xbound.xminGer,PSO.xbound.xminUC]; % Xmin
PSO.xbound.xmax = [PSO.xbound.xmaxGer,PSO.xbound.xmaxUC]; % Xmax



% Limites das velocidades

PSO.vbound.min   = [-0.05*PSO.xbound.xmaxGer,-0.05*PSO.xbound.xmaxUC];    % Vmin
PSO.vbound.max   = [+0.05*PSO.xbound.xmaxGer,+0.05*PSO.xbound.xmaxUC];    % Vmax

PSO.npop = 1000;           % population size
PSO.nger = 50;            % epochs

PSO.acel(1) = 2;          % aceleration constant (pbest)
PSO.acel(2) = 2;          % aceleration constant (gbest)

PSO.inertia.init = 1.5;   % Initial Inertia Weight
PSO.inertia.end  = 0.6;   % Final Inertia Weight


%% CASO OTIMIZAÇÃO 
fun = @Fob_UC;      % Objective function file
f = pso_(fun);

disp(f.fval)
figure(11)
plot(PSO.EVOLUTION)
title('Otimização do Custo')
xlabel('iteração')
ylabel('Custo ($)')

x = f.xval;

%% Resultado por Hora

[Cost]=C_H(x);
disp('Custo por Hora')
disp([[1:length(HORA(:,1))]' Cost.Cenario])

for i=1:8
    figure(i+2)
    C1=Cost.plot(i,1);
    C2=Cost.plot(i,2);
    C3=Cost.plot(i,3);
    C4=Cost.plot(i,4);
    xxx=[C1 C2 C3 C4];
%     plot(Cost.plot)
    pie(xxx)
end

%% Custo por hora

H1=[];
H2=[];
H3=[];
H4=[];
H5=[];
H6=[];
H7=[];
H8=[];
for i = 1 : PSO.nger
    [Cost] = C_H(PSO.EVOLX(i,:));
    H1=[H1 Cost.Cenario(1)];
    H2=[H2 Cost.Cenario(2)];
    H3=[H3 Cost.Cenario(3)];
    H4=[H4 Cost.Cenario(4)];
    H5=[H5 Cost.Cenario(5)];
    H6=[H6 Cost.Cenario(6)];
    H7=[H7 Cost.Cenario(7)];
    H8=[H8 Cost.Cenario(8)];

end
    figure(2)
   pp= plot(1:PSO.nger,H1,1:PSO.nger,H2,1:PSO.nger,H3,1:PSO.nger,H4,1:PSO.nger,H5,1:PSO.nger,H6,1:PSO.nger,H7,1:PSO.nger,H8);
    
    pp(1).Marker = '+';
    pp(2).Marker = '*';
    pp(3).Marker = 'o';
    pp(4).Marker = '^';
    pp(5).Marker = 'v';
    pp(6).Marker = '>';
    pp(7).Marker = '<';
    pp(8).Marker = 'pentagram';
    
    
    xlabel('Iteração')
    ylabel('Custo por Instante de Tempo')
    legend('Hora 1','H2','H3','H4','H5','H6','H7','H8')
    title('Custos em Cada Iteração')
    % axis([0 length(HORA(:,1))+1 0 1.1*max(max(HORA(:,1)))])
%     pause(0.3)
%% Sensibilidade

figure(12)
plot(PSO.W)

toc