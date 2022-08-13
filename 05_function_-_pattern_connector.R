patternConnector <- function(data){
  
  # data: shall be a 2D matrix in which rows are latitudes (S->N), columns are longitudes (W->E)
  # iteration: 

## 1. Comparing the last column (E177.5°) to the first (W180°):
for(i in 1:(dim(data)[1])){
   if(data[i,dim(data)[2]] > 0){
    if(data[i,1] > 0){
       data[i,dim(data)[2]] <- data[i,1]
     }
   }
}


## 2. Checking elements in the last column from N to S (E177.5°):
# the same non-zero value is assigned to southerly located grid cells  
# which is assigned to the most southerly located grid cell:

for(i in (dim(data)[1]-1):1){
  if(data[i,dim(data)[2]] > 0){
    if(data[i+1,dim(data)[2]] > 0){
       data[i,dim(data)[2]] <- data[i+1,dim(data)[2]]
    }
  }
}


## 3. Comparing the first column (W180°) to the last (E177.5°):
# With this step clusters on both sides are grouped into one if it is required:
for(i in 1:dim(data)[1]){
   if(data[i,1] > 0){
     if(data[i,dim(data)[2]] > 0){
        data[i,1] <- data[i,dim(data)[2]]
     }
   }
}


## 4. Checking right and bottom elements from bottomright in the data[,] table:
clust <- c(sort(unique(as.numeric(data[,1]))),
           sort(unique(as.numeric(data[,dim(data)[2]]))))

clust <- clust[clust!=0]
clust2 <- clust[duplicated(clust)]

for(j in (dim(data)[2]-1):1) {
  for(i in (dim(data)[1]-1):1) {

     for(index in clust2) {
       if(data[i,j] > 0){
         if(data[i+1,j] == index || data[i,j+1] == index)
           data[i,j] <- index}
     }
  }
}


## 5. Checking right and up elements from topright in the data[,] table:
# first columns then rows
clust <- c(sort(unique(as.numeric(data[,1]))),
           sort(unique(as.numeric(data[,dim(data)[2]]))))

clust <- clust[clust!=0]
clust2 <- clust[duplicated(clust)]
 
for(j in (dim(data)[2]-1):1) {
   for(i in 2:dim(data)[1]) {

     for(index in clust2) {
       if(data[i,j] > 0){
         if(data[i-1,j] == index || data[i,j+1] == index)
            data[i,j] <- index}
     }
   }
}


## 6. Fixing E177.5° - checking left and down elements from bottomleft in the data[,] table:
# first columns then rows
clust <- c(sort(unique(as.numeric(data[,1]))),
           sort(unique(as.numeric(data[,dim(data)[2]]))))
  
clust <- clust[clust!=0]
clust2 <- clust[duplicated(clust)]
  
index <- c(0) # storing left and down elements
  for(j in 2:(dim(data)[2])) {
    for(i in (dim(data)[1]-1):1) {
      if(data[i,j]>0){
        index[1] <- data[i+1,j]
        index[2] <- data[i,j-1]
        if(index[1]!=0 && index[2]!=0){
          data[i,j] <- min(index[1],index[2])}
        if(index[1]!=0 && index[2]==0){
          data[i,j] <- index[1]}
        if(index[1]==0 && index[2]!=0){
          data[i,j] <- index[2]}
    }
  }
}


## 7. Fixing W180° - checking left and up elements from topleft in the data[,] table:
index <- c(0) # storing left and up elements
  for(j in 2:(dim(data)[2])) {
    for(i in 2:dim(data)[1]) {
      if(data[i,j]>0){
        index[1] <- data[i-1,j]
        index[2] <- data[i,j-1]
        if(index[1]!=0 && index[2]!=0){
          data[i,j] <- min(index[1],index[2])}
        if(index[1]!=0 && index[2]==0){
          data[i,j] <- index[1]}
        if(index[1]==0 && index[2]!=0){
          data[i,j] <- index[2]}
    }
  }
}

return(data)

}  
