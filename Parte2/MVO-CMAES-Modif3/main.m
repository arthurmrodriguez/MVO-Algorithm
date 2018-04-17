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

% To run MVO: [Best_score,Best_pos,cg_curve]=MVO(Universes_no,Max_iteration,lb,ub,dim,fobj)
%__________________________________________

%clear all 
clc
mex cec14_func.cpp

Universes_no=60; %Number of search agents (universes)
FunctionNumbers = 6:10;
tests=1;

%Problem dimension
Problem_Dim = [10,30];

%We're testing with both dimensions: 10 and 30...
for dim=1:length(Problem_Dim)
      
  %Maximum number of iterations: depending on the number
  %of calls to fitness function, which are 10K*Dim
  Max_iteration=(10000*Problem_Dim(dim))/Universes_no;

  %For every function in a total of 20
  for f_index=1:length(FunctionNumbers)
    
    %Load details of the selected benchmark function
    %[lb,ub]=Get_Functions_details(FunctionNumbers(f_index));
    lb = -100;
    ub = 100;
    %Initialize the result vector
    bestResults = zeros(1,tests);
      
    %25 times each function to get an average
    for times=1:tests

      %Execution of the algorithm and seed
      [Best_score,Best_pos, fobj_calls, fobj_LS] = MVO(Universes_no,Max_iteration,lb,ub,Problem_Dim(dim),FunctionNumbers(f_index));
      bestResults(times) = Best_score;      
    end

    %Compute the average of the results
    averageResult = mean(bestResults);
    
    %Results display
    display(['Function : ',num2str(FunctionNumbers(f_index)), ' Dim ',num2str(Problem_Dim(dim)), ' - Function Value (Mean) -> ', num2str(averageResult - (100*FunctionNumbers(f_index)))]);
    display(['Total evaluations -> ',num2str(fobj_calls), ' | LS evaluations -> ', num2str(fobj_LS)]);
  end
  
  
end


        



