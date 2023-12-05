%% Particle Swarm Optimization
% Victor Ferreira Carvalho
% 26/11/2023
%%
% Default is Minimization
%%
function f = pso_(fun)
%% GLOBAL VARIABLES
global PSO 
%% CONSTANTS
% --------------------------------
% Inertial Constant
Wmin = PSO.inertia.end;
Wmax = PSO.inertia.init;
% --------------------------------
% Acelerations Constants
c1 = PSO.acel(1); % pbest
c2 = PSO.acel(2); % gbest
% --------------------------------
% Dimension
ndim = PSO.d;
% --------------------------------
% Population Size and Generation
npop = PSO.npop;
nger = PSO.nger;
% --------------------------------
%% SOME INITIALIZATIONS
% --------------------------------
% Velocities Min and Max
PSO.param.Vmin = [];
PSO.param.Vmax = [];

for k = 1:PSO.npop
  PSO.param.Vmin(k,:)   = PSO.vbound.min;
  PSO.param.Vmax(k,:)   = PSO.vbound.max;
end
% --------------------------------
% Inialize the velocites at time zero
for k = 1:npop
    for   m = 1:ndim
        PSO.param.V(k,m) = PSO.param.Vmin(k,m)+rand*(PSO.param.Vmax(k,m)-PSO.param.Vmin(k,m));
    end
end

% -------------------------------------------------------------------------
% Inicializar
pop0 = zeros(PSO.npop,PSO.d);
xmax = PSO.xbound.xmax ;
xmin = PSO.xbound.xmin ;
PSO.param.xmin = [];
PSO.param.xmax = [];

for k = 1:PSO.npop
    PSO.param.xmin = [PSO.param.xmin; xmin];
    PSO.param.xmax = [PSO.param.xmax; xmax];
    
    for m = 1:PSO.d
        pop0(k,m) = xmin(1,m)+rand*(xmax(1,m)-xmin(1,m));
    end
    
end
PSO.param.pop0 = pop0;
% -------------------------------------------------------------------------
% Population Generation - Function Value Calculation
for k = 1:npop
%         x0 = PSO.param.pop0(k,:);
                %----------------------------------------------------------
                % Binary variables method
                x0 = [PSO.param.pop0(k,1:ndim/2) (PSO.param.pop0(k,ndim/2+1:end)>0.5)];
                %----------------------------------------------------------
        PSO.param.fval(k,1) = feval(fun, x0); % Function Evaluation
end
% --------------------------------
% % PBEST
    PSO.param.pbest.pbest = PSO.param.pop0;
    PSO.param.pbest.fval  = PSO.param.fval;
% --------------------------------
% GBEST
  [~, indx2] = min(PSO.param.pbest.fval);
    PSO.param.gbest.gbest = PSO.param.pop0(indx2,:);
    PSO.param.gbest.gval  = PSO.param.fval(indx2);
% --------------------------------
% GBEST STORING
    PSO.param.store.gbest = PSO.param.gbest.gbest;
    PSO.param.store.gval  = PSO.param.gbest.gval;
% --------------------------------

PSO.W=[];
PSO.EVOLUTION=[];
PSO.EVOLX=[];
%% GENERATIONS
    for iter = 1:nger
%         disp(iter)
        %----------------------------------------------------------------------
        % Inertia Constant
          PSO.param.w(iter,1) = Wmax -iter*(Wmax-Wmin)/nger;
          W = PSO.param.w(iter);
          PSO.W=[PSO.W W];
        %----------------------------------------------------------------------
        % Velocity Updating
            for k = 1:npop
                PSO.param.V(k,:) = W*PSO.param.V(k,:)+ ...
                                                     + c1*rand*(PSO.param.pbest.pbest(k,:)-PSO.param.pop0(k,:))+...
                                                     + c2*rand*(PSO.param.gbest.gbest-PSO.param.pop0(k,:));
            end

        % Evaluation of Feasibility of Velocity (vmin <= v <= vmax)
          PSO.param.V = (PSO.param.V<=PSO.param.Vmin).*(PSO.param.Vmin) + (PSO.param.V>PSO.param.Vmin).*PSO.param.V;
          PSO.param.V = (PSO.param.V>=PSO.param.Vmax).*(PSO.param.Vmax) + (PSO.param.V<PSO.param.Vmax).*PSO.param.V;
        %----------------------------------------------------------------------
        % Position Updating
          PSO.param.pop0 = PSO.param.V + PSO.param.pop0;
        
        % Evaluation of Feasibility of Position (xmin <= x <= xmax)
          PSO.param.pop0 = (PSO.param.pop0<=PSO.param.xmin).*(PSO.param.xmin) + (PSO.param.pop0>PSO.param.xmin).*PSO.param.pop0;
          PSO.param.pop0 = (PSO.param.pop0>=PSO.param.xmax).*(PSO.param.xmax) + (PSO.param.pop0<PSO.param.xmax).*PSO.param.pop0;
        %----------------------------------------------------------------------    
        % Updating PBEST
            for k = 1:npop
                
                %----------------------------------------------------------
                % Binary variables method
                x0 = [PSO.param.pop0(k,1:ndim/2) (PSO.param.pop0(k,ndim/2+1:end)>0.5)];
                %----------------------------------------------------------
                    
%                     x0 = PSO.param.pop0(k,:);
                    PSO.param.fval(k,1) = feval(fun, x0);             % Function Evaluation

                    if PSO.param.fval(k,1) <= PSO.param.pbest.fval(k,1)
                        PSO.param.pbest.pbest(k,:) = PSO.param.pop0(k,:);
                        PSO.param.pbest.fval(k,:)  = PSO.param.fval(k,1);
                    end
            end
        % --------------------------------
        % Updating GBEST
          [~, indx2] = min(PSO.param.pbest.fval);
           fbest = PSO.param.fval(indx2);

           if fbest <= PSO.param.gbest.gval
                PSO.param.gbest.gbest = PSO.param.pop0(indx2,:);
                PSO.param.gbest.gval  = PSO.param.fval(indx2);          
           end
         % Storing
           PSO.param.store.gbest(iter,:) = PSO.param.gbest.gbest;
           PSO.param.store.gval(iter,1)  = PSO.param.gbest.gval;
           f.xval = [PSO.param.gbest.gbest(1,1:ndim/2) (PSO.param.gbest.gbest(1,ndim/2+1:end)>0.5)];
           graphs
           PSO.EVOLUTION=[PSO.EVOLUTION,PSO.param.gbest.gval];
           PSO.EVOLX=[PSO.EVOLX; f.xval];
        %----------------------------------------------------------------------    
    end
%% OUTPUT
f.xval = PSO.param.gbest.gbest;
f.fval = PSO.param.gbest.gval;

f.xval = [PSO.param.gbest.gbest(1,1:ndim/2) (PSO.param.gbest.gbest(1,ndim/2+1:end)>0.5)];


f.fval = PSO.param.gbest.gval;

%%
end