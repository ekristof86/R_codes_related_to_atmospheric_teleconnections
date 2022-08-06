############################################################
############ DETECTING POTENTIAL ACTION CENTERS ############
############################################################

# This script finds the coordinates of the potential action centers (PotACs)
# (pairs of grid cells - in other words poles - which have the same correlation
# value in the strongest negative correlation field).

# The input file is the RDS file created with the script function_-_computing_absolute_minimum_correlations.R.

# The output will be a csv file which contains the following data:
# ind_lon1: the index of the longitude of the first pole of the potAC
# ind_lon2: the index of the longitude of the second pole of the potAC
# coord_lon1: the geographical longitude of the first pole of the potAC
# coord_lon2: the geographical longitude of the second pole of the potAC
# ind_lat1: the index of the latitude of the first pole of the potAC
# ind_lat2: the index of the latitude of the second pole of the potAC
# coord_lat1: the geographical latitude of the first pole of the potAC
# coord_lat2: the geographical latitude of the second pole of the potAC



######### FUNCTION #########
# lon: the values of the geographical longitude available in the strongest negative correlation field
# lat: the values of the geographical latitude available in the strongest negative correlation field
# absmincor: title of the file which contains the strongest negative correlations (input data)
# csv_name: title of the file which contains coordinates of the PotACs (output data)

# Required functions from R packages:
library(installr)
check.integer <- installr:::check.integer



################## SEARCH FOR POTENTIAL ACTION CENTERS ##################

find_potACs <- function(absmincor=absmincor, csv_name=csv_name){
  
  coord_list <- list(NA)
  absmincor_vector <- as.numeric(absmincor[1:144,1:36]) # 90? is omitted
  last <- length(absmincor_vector[duplicated(absmincor_vector)])
  coord_matr <- array(NA, dim=c(last,9))
    
  for (vector in 1:last) {
    coord_list[[vector]] <- which(absmincor == absmincor_vector[duplicated(absmincor_vector)][vector], TRUE)
  }
  
  try(if(check.integer(length(unlist(coord_list))/4)==FALSE) stop("Pair of lon/lat coordinates is missing!!"))
    
  for (vector in 1:last) {
    coord_matr[vector,] <- cbind(
      coord_list[[vector]][1,1], coord_list[[vector]][2,1],
      lon[coord_list[[vector]][1,1]], lon[coord_list[[vector]][2,1]], 
      absmincor_vector[duplicated(absmincor_vector)][vector],
      coord_list[[vector]][1,2], coord_list[[vector]][2,2],
      lat[coord_list[[vector]][1,2]], lat[coord_list[[vector]][2,2]]
    )
  }
    
  try(if(nrow(coord_matr)!=last) stop("We lost at least one potential action center!!"))
  coord_matr <- as.data.frame(coord_matr)
  colnames(coord_matr) <- c("ind_lon1","ind_lon2","coord_lon1","coord_lon2","corr",
                            "ind_lat1","ind_lat2","coord_lat1","coord_lat2")
    
    # try(if(coord_matr$ind_lat1==37) stop("N90 is a coordinate!!"))
    # try(if(coord_matr$ind_lat2==37) stop("N90 is a coordinate!!"))
    
  coord_matr <- coord_matr[order(coord_matr$corr, decreasing=FALSE),]
  write.table(coord_matr, csv_name, sep=";", row.names=FALSE)
}
  
