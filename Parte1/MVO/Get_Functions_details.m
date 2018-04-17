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

% This function containts full information and implementations of the benchmark 
% functions in Table 1, Table 2, and other test functins from the literature 

% lb is the lower bound: lb=[lb_1,lb_2,...,lb_d]
% up is the uppper bound: ub=[ub_1,ub_2,...,ub_d]
% dim is the number of variables (dimension of the problem)

function [lb,ub] = Get_Functions_details(F)


switch F
    case 1
        lb=-100;
        ub=100;
        
    case 2
        lb=-100;
        ub=100;
        
    case 3
        lb=-100;
        ub=100;
   
    case 4
        lb=-100;
        ub=100;
        
        
    case 5
        lb=-100;
        ub=100;
        
    case 6
        lb=-100;
        ub=100;
        
    case 7
        lb=-1000;
        ub=1000;
        
    case 8
        lb=-32;
        ub=32;
        
    case 9
        lb=-5;
        ub=5;
        
    case 10
        lb=-5;
        ub=5;
        
    case 11
        lb=-0.5;
        ub=0.5;
   
    case 12
        lb=-100;
        ub=100;
        
        
    case 13
        lb=-3;
        ub=1;
        
    case 14
        lb=-100;
        ub=100;
        
    case 15
        lb=-5;
        ub=5;
        
    case 16
        lb=-5;
        ub=5;
        
        
    case 17
        lb=-5;
        ub=5;
        
    case 18
        lb=-5;
        ub=5;
        
    case 19
        lb=-5;
        ub=5;
        
    case 20
        lb=-5;
        ub=5;
end

end
