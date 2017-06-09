#Initialize gambles in a dataframe
gambles <- data.frame(safe_1 = 100, safe_2 = 80, 
                      risky_1 = 190, risky_2 = 5, 
                      p_1 = seq(0.1,1,0.1))

gambles$p_2 = 1-gambles$p_1

# exp_val <- function(alpha,gamma){
exp_val_2 <- function(alpha, gamma, gambles){  
  
  gambles$wp_1 <- exp(-(-log(gambles$p_1))^gamma)
  gambles$wp_2 <- 1 - gambles$wp_1
  
  #Exponentiate monetary values to get utilities
  gambles$su_1 <- gambles$safe_1^alpha
  gambles$su_2 <- gambles$safe_2^alpha
  gambles$ru_1 <- gambles$risky_1^alpha
  gambles$ru_2 <- gambles$risky_2^alpha
    
  #Matrix multiplication of weighted probabilities with utilities to get expected values per gamble
  
  gambles$ut_1 <- gambles$wp_1*gambles$su_1 + gambles$wp_2*gambles$su_2
  gambles$ut_2 <- gambles$wp_1*gambles$ru_1 + gambles$wp_2*gambles$ru_2
  
  # Softmax method to find probbility of choosing the safe bet
  gambles$prob_safe <- exp(gambles$ut_1)/(exp(gambles$ut_1) + exp(gambles$ut_2))
  
  #binary output of choices
  gambles$choice <- ifelse(gambles$prob_safe > 0.5, 1, 0)
  
  #percent of safe choices
  gambles$percent<- sum(gambles$choice)/10
  
  
  return (gambles)
}


#heatmap 
#for (i in seq(0,5,0.1)){
  #for(j in seq(0,5,0.1)){
    #matrix <- data.frame(gambles$percent)
    #heatmap(matrix,  aes(alpha, gamma)) 
    #+ geom_tile() +
    #scale_fill_gradient(low="white", high="darkgreen", name="First")
  #}
#}

#I have some issues with the arguments of the heatmapp function. Also, I think that if I use 
#the variables i and j as counters then ex_val(i,j,gambles) should appear somewhere. Any help
#or insight is welcome. What other graph methods could I use to model this?

# Here are the issues I'm seeing in your code:
# - Where is this 'heatmap' function coming from? You initialize a plot in ggplot2 using the 'ggplot' function.
# - What is the intended output of the for loop? As it is the indices (i, j) are not being used for anything and the plotting command is within the loop so you would be making i*j number of plots when you just want one
# - You currently just have a function to simulate choices given a single value of alpha and a single value of gamma. You need to first figure out how to run this for multiple values of both parameters. It seems that's what you're trying to do in the for loop. To make it work try:
alphas = seq(0,1,0.1)
gammas = seq(0,1,0.1)
counter = 0
output <- data.frame(alpha=rep(NA, 121), gamma=rep(NA,121), percent_safe=rep(NA,121))
for (i in 1:length(alphas)){
  for(j in 1:length(gammas)){
    counter = counter+1
    alpha = alphas[i]
    gamma = gammas[j]
    output$alpha[counter] = alpha
    output$gamma[counter] = gamma
    output$percent_safe[counter] = unique(exp_val_2(alpha, gamma, gambles)$percent)
  }
}

library(ggplot2)

ggplot(output, aes(alpha, gamma))+
  geom_raster(aes(fill=percent_safe))

