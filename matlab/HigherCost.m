%% Determinação da Unidade Geradora com Maior Custo

function [] = HigherCost
global P UTE

a = UTE(:,1);
b = UTE(:,2);
c = UTE(:,3);

GER = min(UTE(:,5));

[~,P] = max(c*(GER.^2)' + b*(GER)' + a);
% (c*(GER.^2)' + b*(GER)' + a)
end