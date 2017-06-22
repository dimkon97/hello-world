



function [] = negative_likelyhood(A,start,step,stop)

%initialize variables


[alpha,gamma] = meshgrid(start:step:stop);
alpha_min_total = zeros(length(A)/10,1);
gamma_min_total = zeros(length(A)/10,1);
min_total = zeros(length(A)/10,1);
k = 0


for i = 1:10:length(A);
    
   %calculate the number of 1's in an individuals answer
    num_ones = 0;
    first_sum = 0;
    second_sum = 0;
    log_P = zeros((stop-start)/step + 1);
    
    for j = i:(i+9);
        
        if A(j) == 1;
            num_ones = num_ones + 1;
        end
    end
        
    

    for p = 0.1:0.1:(num_ones/10);
    
        %model utility and probability of choosing safe option
        U_X = real((exp(-(log(p)).^gamma)*(100.^alpha) + (1-exp(-(log(p)).^gamma))*(80.^alpha)));

        U_Y = real((exp(-(log(p)).^gamma)*(190.^alpha) + (1-exp(-(log(p)).^gamma))*(5.^alpha)));

        P = 1./(1+exp(U_Y-U_X));
    
    
        % set threshold to avoid negative log of probability to be
        % extremely large
        
        for i = 1:((stop-start)/step + 1);
            for j = 1:((stop-start)/step + 1);
                if P(i,j) > 10^(-80);
                log_P(i,j) = log(P(i,j));
                else
                log_P(i,j) = -80;
                end
            end
        end
            
   
    % compute the sum of negative log likelihoods the produce output=1 
    first_sum = first_sum - log_P;
    
    end


    for p = (num_ones/10 + 0.1):0.1:1;
    
        %model utility and probability of choosing safe option
        U_X = real((exp(-(log(p)).^gamma)*(100.^alpha) + (1-exp(-(log(p)).^gamma))*(80.^alpha)));

        U_Y = real((exp(-(log(p)).^gamma)*(190.^alpha) + (1-exp(-(log(p)).^gamma))*(5.^alpha)));

        P = 1./(1+exp(U_Y-U_X));
    
        % compute the sum of negative log likelihoods the produce output=0
        
        second_sum = second_sum - (1-log_P);
    
    
    end

 % calculate the sum of the two "kinds" of negative log likelihood
    neg_log_like = first_sum + second_sum;


 %find alpha and gamma for which negative log likelihood is minimized for
 %every individual

    min = 700;
    for i = 1:((stop-start)/step + 1);
        for j = 1:((stop-start)/step + 1);
            if neg_log_like(i,j) < min;
                min = neg_log_like(i,j);
                alpha_min = (j-1)/100;
                gamma_min = (i-1)/100;
            end
        end
    end
   
    
    %create matrices with alpha_min, gamma_min, min for every individual
    k = k + 1;
     
    alpha_min_total(k,1) = alpha_min;
    gamma_min_total(k,1) = gamma_min;
    min_total(k,1) = min;
         
    
end

disp(alpha_min_total);
%Draw graphs

figure();
hist(alpha_min_total);
xlabel('alpha values');
ylabel('frequency');
title('Frequency of alpha values for which negative log likelihood is minimized')

hold on

figure();
hist(gamma_min_total);
xlabel('gamma values');
ylabel('frequency');
title('Frequency of gamma values for which negative log likelihood is minimized')

hold on

figure();
hist(min_total);
xlabel('minimum negative likelihood');
ylabel('frequency');
title('Frequency of minimum negative log likelihoods across all individuals')

hold on








end





    




