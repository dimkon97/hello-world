[alpha,gamma] = meshgrid(0:0.01:2);

U_X1 = real((exp(-(log(0.4)).^gamma)*(100.^alpha) + (1-exp(-(log(0.6)).^gamma))*(80.^alpha)));

U_Y1 = real((exp(-(log(0.4)).^gamma)*(190.^alpha) + (1-exp(-(log(0.6)).^gamma))*(5.^alpha)));

P = (exp(U_X1)./(exp(U_X1) + exp(U_Y1)));


surf(alpha,gamma,U_Y1);
surf(alpha,gamma,P);
surf(alpha,gamma,U_X1);

colormap winter;
colorbar;
xlabel('Alpha');
ylabel('Gamma');




