%This function takes as an input the range of alpha and gamma values (as well as the step of increase)
%and produces three graphs that represent the percentage of safe choices an "ideal" candidate would make 
%given three choice models (hardmax, binomial, epsilon greedy).



function[] = graphs_of_different_choice_functions(min, max, step) 


%Initialize range of alpha and gamma values

[alpha,gamma] = meshgrid(min:step:max);
sum_P_hardmax = zeros((max-min)/step + 1);
sum_P_binomial = zeros((max-min)/step + 1);
sum_P_epsilon = zeros((max-min)/step + 1);
binomial_choice = zeros((max-min)/step + 1);
epsilon_choice = zeros((max-min)/step + 1);

for p = 0.1:0.1:1;
    
 %model utility and probability of choosing safe option
    U_X = real((exp(-(log(p)).^gamma)*(100.^alpha) + (1-exp(-(log(p)).^gamma))*(80.^alpha)));

    U_Y = real((exp(-(log(p)).^gamma)*(190.^alpha) + (1-exp(-(log(p)).^gamma))*(5.^alpha)));

    P = 1./(1+exp(U_Y-U_X));

 %sum over probabilities of 10 different bets using Hardmax
    
    sum_P_hardmax = sum_P_hardmax + round(P);


end

% matrix with averaged binary output for 10 different bets using Hardmax

bin_P_hardmax = 1./10.*sum_P_hardmax;


for p = 0.1:0.1:1;
    
% model utility and probability of choosing safe option
    U_X = real((exp(-(log(p)).^gamma)*(100.^alpha) + (1-exp(-(log(p)).^gamma))*(80.^alpha)));

    U_Y = real((exp(-(log(p)).^gamma)*(190.^alpha) + (1-exp(-(log(p)).^gamma))*(5.^alpha)));

    P = 1./(1+exp(U_Y-U_X));

%binomial distribution method
    for i = 1:((max-min)/step + 1);
        for j = 1:((max-min)/step + 1);
            R = binornd(1,P(i,j));
            if R == 0
            binomial_choice(i,j) = 0;
            else
            binomial_choice(i,j) = 1;
            
            end    
        
        end       
    

    end


%sum over probabilities of 10 different bets using binomial distribution
    sum_P_binomial = sum_P_binomial + binomial_choice;

end

% matrix with averaged binary output for 10 different bets using binomial
% distribution

bin_P_binomial = 1./10.*sum_P_binomial;

for p = 0.1:0.1:1;
    
 %model utility and probability of choosing safe option
    U_X = real((exp(-(log(p)).^gamma)*(100.^alpha) + (1-exp(-(log(p)).^gamma))*(80.^alpha)));

    U_Y = real((exp(-(log(p)).^gamma)*(190.^alpha) + (1-exp(-(log(p)).^gamma))*(5.^alpha)));

    P = 1./(1+exp(U_Y-U_X));

 %epsilon-greedy method
 
    epsilon = rand;
    for i = 1:((max-min)/step + 1);
         for j = 1:((max-min)/step + 1);
             Q = binornd(1, epsilon);
             if Q == 1;
                 if U_X(i,j) > U_Y(i,j);
                     epsilon_choice(i,j) = 1;
                 else
                     epsilon_choice(i,j) = 0;
                    
                 end
             else
                 S = binornd(1, 0.5);
                 if S == 0;
                     epsilon_choice(i,j) = 0;
                 else
                     epsilon_choice(i,j) = 1;
                 end
                 
             end
             
         end
     end
     
     sum_P_epsilon = sum_P_epsilon + epsilon_choice;
     
end
                 
% matrix with averaged binary output for 10 different bets using
% epsilon_greedy distribution
 
bin_P_epsilon = 1./10.*sum_P_epsilon;

% colourmap graph of bin_P_binomial
figure();
surf(alpha,gamma,bin_P_binomial);
colormap winter;
colorbar
xlabel('alpha');
ylabel('gamma');
title('Graph of percentage of safe bets as a function of alpha and gamma (Binomial choice model)')

hold on

% colourmap graph of bin_P_hardmax
figure();
surf(alpha,gamma,bin_P_hardmax);
colormap winter;
colorbar
xlabel('alpha');
ylabel('gamma');
title('Graph of percentage of safe bets as a function of alpha and gamma (Hardmax choice model)')

hold on

% colourmap graph of bin_P_epsilon
figure();
surf(alpha,gamma,bin_P_epsilon);
colormap winter;
colorbar
xlabel('alpha');
ylabel('gamma');
title('Graph of percentage of safe bets as a function of alpha and gamma (Epsilon-greedy choice model)')

hold on


end



