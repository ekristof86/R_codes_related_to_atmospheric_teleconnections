########################
### PATTERN DETECTOR ###
########################

# The following codes are written by Roland Hollós and Erzsébet Kristóf.

# Clusters are identified in a deterministic way as follows:
# Grid cells with the value of 1 are merged into a single cluster if those are neighboring grid cells.
# The grid cell "A" is the neighbor of the grid cell "B" if A is located to the left / right / bottom / up from B.

# Creating an array (calles as tomb) which contains random numbers.
# set.seed(123) # To make the example repeatable.
tomb <- array(sample(c(0,1),100,replace = TRUE,prob = c(0.7,0.3)),dim = c(10,15))


######### EXAMINING NEIGHBORING CELLS #########

leftElement <- function(tomb,index){
  rownum <- dim(tomb)[1]
  return(tomb[(index-rownum)])
}

upElement <- function(tomb,index){
  if((index %% dim(tomb)[1]) == 1){
    return(0)
  } else {
    return(tomb[index-1])
  }
}

patternDetector <- function(tomb){
  indGroup <- list()
  tombSize <- length(tomb) 
  rownum <- dim(tomb)[1]
  for(i in seq(tombSize)){
    
    up <- upElement(tomb,i)
    if(tomb[i]!=0){
      
      if(i <= rownum){
        
        
        if(up > 0){
          indGroup[[as.character(up)]] <- c(indGroup[[as.character(up)]],i)
          tomb[i] <- up
        } else {
          indGroup[[as.character(i)]] <- i
          tomb[i] <- i
        }
      } else {
        left <- leftElement(tomb,i)
        # if(i == 65){
        #   browser()
        # }
        if((up > 0) && (left > 0)){
          if(up == left){
            tomb[i] <- up
            indGroup[[as.character(left)]] <- c(indGroup[[as.character(left)]],i)
          } else {
            if(left < up){
              tomb[indGroup[[as.character(up)]]] <- left
              tomb[i] <- left
              indGroup[[as.character(left)]] <- c(indGroup[[as.character(up)]],indGroup[[as.character(left)]],i)
            } else {
              tomb[indGroup[[as.character(left)]]] <- up
              tomb[i] <- up
              indGroup[[as.character(up)]] <- c(indGroup[[as.character(up)]],indGroup[[as.character(left)]],i)
            }
            
          }
          
          
        } else {
          if((up == 0) && (left == 0)){
            
            tomb[i] <- i
            indGroup[[as.character(i)]] <- i 
          } else {
            
            if((up >= 1) && (left < 1)){
              
              indGroup[[as.character(up)]] <- c(indGroup[[as.character(up)]],i)
              tomb[i] <- up
            }
            
            if((left >=1) && (up < 1)){
              indGroup[[as.character(left)]] <- c(indGroup[[as.character(left)]],i)
              tomb[i] <- left
            }
          }  
        }
        
      }
    }
  }
  
  return(tomb)
}

patternDetector(tomb)


######### WRITE INTO FILE THE RESULTS #########

# write.csv(patternDetector(tomb), "Pattern_detection_example.csv")
