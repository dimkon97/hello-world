#assume p1 = 0.1 and p2 = 0.9
# I am trying to find the average value of P, to give as an idea if the threshold is actually 0.5 or depends on the choices of
#p1,p2,alpha,gamma,payoff1,payoff2


[alpha,gamma] = meshgrid(0:0.01:2);

U_X1 = real((exp(-(log(0.1)).^gamma)*(100.^alpha) + (1-exp(-(log(0.9)).^gamma))*(80.^alpha)));

U_Y1 = real((exp(-(log(0.1)).^gamma)*(190.^alpha) + (1-exp(-(log(0.9)).^gamma))*(5.^alpha)));

P = (exp(U_X1)./(exp(U_X1) + exp(U_Y1)));

figure()
surf(alpha,gamma,U_Y1);

figure()
surf(alpha,gamma,P);

figure()
surf(alpha,gamma,U_X1);

colormap winter;
colorbar;
xlabel('Alpha');
ylabel('Gamma');




