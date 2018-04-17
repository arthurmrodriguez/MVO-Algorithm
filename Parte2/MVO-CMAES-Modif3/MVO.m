%_______________________________________________________________________________________%
%  Multi-Verse Optimizer (MVO) source codes demo version 1.0                            %
%                                                                                       %
%  Developed in MATLAB R2011b(7.13)                                                     %
%                                                                                       %
%  Author and programmer: Seyedali Mirjalili                                            %
%                                                                                       %
%         e-Mail: ali.mirjalili@gmail.com                                               %
%                 seyedali.mirjalili@griffithuni.edu.au                                 %
%                                                                                       %
%       Homepage: http://www.alimirjalili.com                                           %
%                                                                                       %
%   Main paper:                                                                         %
%                                                                                       %
%   S. Mirjalili, S. M. Mirjalili, A. Hatamlou                                          %
%   Multi-Verse Optimizer: a nature-inspired algorithm for global optimization          %
%   Neural Computing and Applications, in press,2015,                                   %
%   DOI: http://dx.doi.org/10.1007/s00521-015-1870-7                                    %
%                                                                                       %
%_______________________________________________________________________________________%

% You can simply define your cost in a seperate file and load its handle to fobj
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% Max_iteration = maximum number of generations
% SearchAgents_no = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single number numbers

%__________________________________________

function [Best_universe_Inflation_rate,Best_universe, fobj_count, fobj_LS]=MVO(N,Max_time,lb,ub,dim,functionNumber)

%Two variables for saving the position and inflation rate (fitness) of the best universe
%We also pre-allocate the sorted universes variable for saving runtime
Best_universe=zeros(1,dim);
Sorted_universes = zeros(1,dim);
Best_universe_Inflation_rate=inf;

%Initialize the positions of universes
Universes=initialization(N,dim,ub,lb);

%Minimum and maximum of Wormhole Existence Probability (min and max in
% Eq.(3.3) in the paper
WEP_Max=1;
WEP_Min=0.2;

%Convergence_curve=zeros(1,Max_time);

%Iteration(time) counter and fobj calls
Time=1;
fobj_count = 0;
fobj_LS = 0;
FOBJ_MAX = Max_time * N;
WEP_Factor = (WEP_Max-WEP_Min)/Max_time;

%Defines the accuracy in the local search: the higher, the accurate the
%solution. The author uses 6 as a start value, but 4 times of iterations we
%have in these problems, we're going to use 4 times the P
factor_P = 6*4;
TDR_Factor = 1/factor_P;

%Maximum number of parallel universes created inside the LS wich has a
%maximum number of fitness function calls. The LS will be called only if
%the actual calls to fitness function is over an established threshold 
MaxIt_LS= 300;
LS_Threshold = 0.70*FOBJ_MAX;

%Main loop
while Time<Max_time+1 && fobj_count < FOBJ_MAX
    
    %Eq. (3.3) in the paper
    WEP=WEP_Min+Time*(WEP_Factor);
    
    %Travelling Distance Rate (Formula): Eq. (3.4) in the paper
    TDR=1-((Time)^(TDR_Factor)/(Max_time)^(TDR_Factor));
    
    %Inflation rates (I) (fitness values)
    Inflation_rates=zeros(1,size(Universes,1));
    
    for i=1:size(Universes,1)
        
        %Boundary checking (to bring back the universes inside search
        % space if they go beyoud the boundaries
        Flag4ub=Universes(i,:)>ub;
        Flag4lb=Universes(i,:)<lb;
        Universes(i,:)=(Universes(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        %Calculate the inflation rate (fitness) of universes
        Inflation_rates(1,i)=cec14_func(Universes(i,:)',functionNumber);
        fobj_count = fobj_count +1;
        
        %Elitism: the universe with less inflation rate would be selected
        %as the best
        if Inflation_rates(1,i)<Best_universe_Inflation_rate
            Best_universe_Inflation_rate=Inflation_rates(1,i);
            Best_universe=Universes(i,:);
        end
        
    end
    
    %Sort by inflation rates in ascendant order
    [~,sorted_indexes]=sort(Inflation_rates);
    
    %Creates the matrix of sorted universes by its inflation rate
    for newindex=1:N
        Sorted_universes(newindex,:)=Universes(sorted_indexes(newindex),:);
    end
    
    %__________________________________________

    %Local Search is introduced here: applied to the best solution we've
    %found, our CMAES based LS will be run when the count of fitness
    %function calls is above a predefined threshold.
    if(fobj_count > LS_Threshold && rand > 0.25)
      
      %Get the best universe
      best_universe = Sorted_universes(1,:);
      fitness_bu = Inflation_rates(sorted_indexes(1));
      
      %Apply LS to the best universe and obtain the new best universe and
      %its fitness value
      [BestUniverse,fobj_calls]= CMAES_LS(best_universe,fitness_bu,functionNumber,dim,ub,lb, TDR,MaxIt_LS);
      
      %Update of the values
      new_BU = struct2cell(BestUniverse);
      Sorted_universes(1,:) = new_BU{1};
      Inflation_rates(sorted_indexes(1)) = new_BU{3};
      fobj_count = fobj_count + fobj_calls;
      fobj_LS = fobj_LS + fobj_calls;
    end
    %__________________________________________
    
    %Normalized inflation rates (NI in Eq. (3.1) in the paper)
    normalized_Inflation_rates=normr(Inflation_rates);
    
    Universes(1,:)= Sorted_universes(1,:);
    
    %Update the Position of universes: exchanging objects through WormH,
    %BHs and WHs
    for i=2:size(Universes,1)%Starting from 2 since the first one is the elite
        Black_hole_index=i;
     
        for j=1:size(Universes,2)
            r1=rand();
            
            %Exploration
            if r1<normalized_Inflation_rates(i)
                White_hole_index=RouletteWheelSelection(-normalized_Inflation_rates);% for maximization problem -sorted_Inflation_rates should be written as sorted_Inflation_rates
                if White_hole_index==-1
                    White_hole_index=1;
                end
                %Eq. (3.1) in the paper
                Universes(Black_hole_index,j)=Sorted_universes(White_hole_index,j);
            end
            
            %Explotation
            if (size(lb,2)==1)
                %Eq. (3.2) in the paper if the boundaries are all the same
                r2=rand();
                if r2<WEP
                    r3=rand();
                    if r3<0.5
                        Universes(i,j)=Best_universe(1,j)+TDR*((ub-lb)*rand+lb);
                    end
                    if r3>0.5
                        Universes(i,j)=Best_universe(1,j)-TDR*((ub-lb)*rand+lb);
                    end
                end
            end
            
            if (size(lb,2)~=1)
                %Eq. (3.2) in the paper if the upper and lower bounds are
                %different for each variables
                r2=rand();
                if r2<WEP
                    r3=rand();
                    if r3<0.5
                        Universes(i,j)=Best_universe(1,j)+TDR*((ub(j)-lb(j))*rand+lb(j));
                    end
                    if r3>0.5
                        Universes(i,j)=Best_universe(1,j)-TDR*((ub(j)-lb(j))*rand+lb(j));
                    end
                end
            end
            
        end
    end
    
    %Update the convergence curve
    %Convergence_curve(Time)=Best_universe_Inflation_rate;
    Time=Time+1;
end



