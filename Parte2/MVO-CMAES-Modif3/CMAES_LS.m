%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA108
% Project Title: Covariance Matrix Adaptation Evolution Strategy (CMA-ES)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [BestSol,fobj_calls] = CMAES_LS(Universe,fitness_bu,fobj_num,dim,ub,lb,TDR, MaxIt)

% Problem Settings
nVar=dim;               % Number of Unknown (Decision) Variables
VarSize=[1 nVar];       % Decision Variables Matrix Size
VarMin= lb;             % Lower Bound of Decision Variables
VarMax= ub;             % Upper Bound of Decision Variables

% Maximum Number of Iterations
fobj_calls = 0;
% Population Size (and Number of Offsprings)
lambda=0.5*dim;

% Number of Parents
mu=round(lambda/2);

% Parent Weights
w=log(mu+0.5)-log(1:mu);
w=w/sum(w);

% Number of Effective Solutions
mu_eff=1/sum(w.^2);

% Step Size Control Parameters (c_sigma and d_sigma);
sigma0=0.3*(VarMax-VarMin);
cs=(mu_eff+2)/(nVar+mu_eff+5);
ds=1+cs+2*max(sqrt((mu_eff-1)/(nVar+1))-1,0);
ENN=sqrt(nVar)*(1-1/(4*nVar)+1/(21*nVar^2));

% Covariance Update Parameters
cc=(4+mu_eff/nVar)/(4+nVar+2*mu_eff/nVar);
c1=2/((nVar+1.3)^2+mu_eff);
alpha_mu=2;
cmu=min(1-c1,alpha_mu*(mu_eff-2+1/mu_eff)/((nVar+2)^2+alpha_mu*mu_eff/2));
hth=(1.4+2/(nVar+1))*ENN;

%Initialization

ps=cell(MaxIt,1);
pc=cell(MaxIt,1);
C=cell(MaxIt,1);
sigma=cell(MaxIt,1);

ps{1}=zeros(VarSize);
pc{1}=zeros(VarSize);
C{1}=eye(nVar);
sigma{1}=sigma0;

%Declaration of a struct with position, step and cost
empty_individual.Position=[];
empty_individual.Step=[];
empty_individual.Cost=[];

M=repmat(empty_individual,MaxIt,1);
M(1).Position=Universe;%unifrnd(VarMin,VarMax,VarSize);
M(1).Step=zeros(VarSize);
M(1).Cost=fitness_bu;

BestSol=M(1);
BestCost=zeros(MaxIt,1);

% CMA-ES Main Loop

for g=1:MaxIt
    
    % Generate Samples
    pop=repmat(empty_individual,lambda,1);
    for i=1:lambda
        %Initialization of the population of parents
        pop(i).Step=mvnrnd(zeros(VarSize),C{g});
        pop(i).Position=(BestSol.Position)+TDR*(sigma{g}*pop(i).Step);
        
        pop(i).Cost=cec14_func(pop(i).Position',fobj_num);
        fobj_calls = fobj_calls+1;
        
        % Update Best Solution Ever Found
        if pop(i).Cost<BestSol.Cost
            BestSol=pop(i);
        end
    end
    
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
  
    % Save Results
    BestCost(g)=BestSol.Cost;
    
    % Exit At Last Iteration
    if g==MaxIt
        break;
    end
        
    % Update Mean
    M(g+1).Step=0;
    for j=1:mu
        M(g+1).Step=M(g+1).Step+w(j)*pop(j).Step;
    end
    
    %Evaluation of the next solution
    M(g+1).Position=M(g).Position+sigma{g}*M(g+1).Step;
    M(g+1).Cost=cec14_func(M(g+1).Position',fobj_num);
    fobj_calls = fobj_calls+1;
    
    if M(g+1).Cost<BestSol.Cost
        BestSol=M(g+1);
    end
    
    % Update Step Size
    ps{g+1}=(1-cs)*ps{g}+sqrt(cs*(2-cs)*mu_eff)*M(g+1).Step/chol(C{g})';
    sigma{g+1}=sigma{g}*exp(cs/ds*(norm(ps{g+1})/ENN-1))^0.3;
    
    % Update Covariance Matrix
    if norm(ps{g+1})/sqrt(1-(1-cs)^(2*(g+1)))<hth
        hs=1;
    else
        hs=0;
    end
    delta=(1-hs)*cc*(2-cc);
    pc{g+1}=(1-cc)*pc{g}+hs*sqrt(cc*(2-cc)*mu_eff)*M(g+1).Step;
    C{g+1}=(1-c1-cmu)*C{g}+c1*(pc{g+1}'*pc{g+1}+delta*C{g});
    for j=1:mu
        C{g+1}=C{g+1}+cmu*w(j)*pop(j).Step'*pop(j).Step;
    end
    
    % If Covariance Matrix is not Positive Defenite or Near Singular
    [V, E]=eig(C{g+1});
    if any(diag(E)<0)
        E=max(E,0);
        C{g+1}=V*E/V;
    end
    
end

end