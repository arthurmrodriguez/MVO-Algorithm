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

clear all 
clc

Universes_no=50; %Number of search agents (universes)
FunctionNumbers = 1:7;

%Problem dimension
Problem_Dim = [10,30];
Max_iteration=500; %Maximum numbef of iterations

for f_index=1:length(FunctionNumbers)
    
  %Load details of the selected benchmark function
  [lb,ub]=Get_Functions_details(FunctionNumbers(f_index));
  
  %Execution of the algorithm
  [Best_score,Best_pos,cg_curve]=MVO(Universes_no,Max_iteration,lb,ub,Problem_Dim(1,1),FunctionNumbers(f_index));

  %Results display
  display(['Function : ',num2str(FunctionNumbers), ' Dim ',num2str(Problem_Dim(1,1)), ' - Function Value -> ', num2str(Best_score)]);
  
end


        



