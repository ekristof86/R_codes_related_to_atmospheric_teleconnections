##############################################################################
############ ASSOCIATING CLUSTERS TO THE POTENTIAL ACTION CENTERS ############
##############################################################################

######### INPUT DATA #########

### Required package:
library(data.table)

## Data files with clusters of detected teleconnections and store relevant data:
path_absmincors <- "D:/.../"
path_CPs <- "D:/.../"
path_PotACs <- "D:/.../"
path_PotACs_with_cluster <- "D:/.../"
path_main_output_files <- "D:/.../"

# RCP4.5:
simulation <- "RCP_4.5"
modname <- c("GCM")
time_periods  <- c("2006-2035")

# quantiles:
pm_quant <- seq(0.025,0.975,0.025)

# percentiles for file titles:
percentiles <- c("02.5","05","07.5","10.0","12.5","15.0","17.5","20.0","22.5","25.0","27.5","30.0",
                 "32.5","35.0","37.5","40.0","42.5","45.0","47.5","50.0","52.5","55.0","57.5","60.0",
                 "62.5","65.0","67.5","70.0","72.5","75.0","77.5","80.0","82.5","85.0","87.5","90.0",
                 "92.5","95.0","97.5")


######### ASSOCIATING CLUSTERS TO THE POTACS #########

# Parameters:
mod_nr <- length(modname) # number of models
peri_nr <- length(time_periods) # number of time periods
quant_nr <- length(pm_quant) # number of quantiles


### LOADING AND EDITING CSV FILES OF POTACS ###
  
for (peri in 1:peri_nr) {
  
  # Open files which contain the potential action centers (PotACs):
  file_PotACs <- Sys.glob(file.path(paste0(path_PotACs,"*",time_periods[peri],"*30y_new_algorithm.csv")))
  pot_AC <- lapply(file_PotACs, function(x) read.table(x, sep=";", header=TRUE))
  
  # Determining the number of rows in each PotAC file:
  nr_of_rows <- as.numeric(lapply(pot_AC, nrow))
  
  # Joining data.frames nested in the list pot_AC:
  pot_AC_all <- do.call(rbind.data.frame, pot_AC)
  class(pot_AC_all)
  
  # Checking:
  dim(pot_AC_all)
  sum(nr_of_rows) == dim(pot_AC_all)[1]
  
  # Adding the columns of modelnames and periods to the data.frame:
  pot_AC_all <- cbind(rep(modname, nr_of_rows), rep(time_periods[peri], sum(nr_of_rows)), pot_AC_all)
  
  # Renaming the first two columns:
  colnames(pot_AC_all)[1:2] <- c("modname", "period")
  
  
  ### LOADING RDS FILES OF CLUSTER PATTERNS (CPS) ###
  
  ### RDS files which contain the clusters of detected teleconnections:
  file_CPs <- Sys.glob(file.path(paste0(path_CPs,"Cluster_patterns",simulation,"*",time_periods[peri],"*")))
  CPs <- lapply(file_CPs, function(x) readRDS(x))
  
  mod_sequence <- seq(1,length(file_CPs),quant_nr)-1 # It is important in case of CP list,
  # in which data are available for 14 GCM and 39 percentiles (14*39=546)
  
  
  ### LOADING RDS FILES OF SNCS ###
  
  ### RDS files of strongest negative correlations:
  file_absmincors <- Sys.glob(file.path(paste0(path_absmincors,"*",time_periods[peri],"*_DJF_del31_daymean_z500_2.5dg.RDS")))
  absmincors <- lapply(file_absmincors, function(x) readRDS(x))
  
  
  ######### CHOOSING ACTION CENTERS IN CASE OF ALL PERCENTILES #########
  
  ### Subtracting 6000 from cluster identifier to get clusters with an ID 0, 1 etc.
  # (0 means no cluster, 1 is the first cluster etc.)
  CPs <- lapply(CPs, function(x, val) x-val, val=6000)
  
  for (mod in 1:mod_nr) {
    for (p in 1:quant_nr) {
      
      pot_AC_all$cluster <- NA # adding new column to the tables of PotACs
      
      CP_mod <- CPs[[mod_sequence[mod]+p]] # selecting the CP array with respect to the model and quantile
      
      for (row in 1:nr_of_rows[mod]) { # walking through the rows of the table of the PotACs
  
        # Associating cluster to each pair of PotAC:
        if(pot_AC_all[pot_AC_all$modname==modname[mod],]$corr[row] <= quantile(as.numeric(absmincors[[mod]]), probs=pm_quant[p], na.rm=TRUE)) {
          pot_AC_all[pot_AC_all$modname==modname[mod],]$cluster[row] <- as.numeric(CP_mod[pot_AC_all[pot_AC_all$modname==modname[mod],]$ind_lat1[row], pot_AC_all[pot_AC_all$modname==modname[mod],]$ind_lon1[row]])
        } else {
          pot_AC_all[pot_AC_all$modname==modname[mod],]$cluster[row] <- 0
        }
      }
      
      # Saving PotACs with clusters in csv fileS:
      write.table(x=pot_AC_all[pot_AC_all$modname==modname[mod],], file=paste0(path_PotACs_with_cluster,simulation,"_",modname[mod],"_",time_periods[peri],"_DJF_Ps_pot_AC_30y_new_algorithm_p_",percentiles[p],".csv"),
                  row.names=FALSE, sep=";")
    }
  }
}


######### STORING DATA IN ONE FILE PER TIME PERIODS: WIDE FORMAT #########

for (peri in 1:peri_nr) {
  # Open files which contain the potential action centers (PotACs) and the associated clusters and join them:
  file_PotACs_with_clusters <- Sys.glob(file.path(paste0(path_PotACs_with_cluster,"*",time_periods[peri],"*")))
  
  # Reading files into the R:
  PotACs_with_clusters <- lapply(file_PotACs_with_clusters, function(x) read.table(x, sep=";", header=TRUE))
  
  # Determining the number of rows in each PotAC file:
  nr_of_rows <- as.numeric(lapply(PotACs_with_clusters, nrow))
  
  PotACs_with_clusters_all_percentiles <- list(NA)
  
  for (mod in seq(1,length(file_PotACs_with_clusters),quant_nr)) {
    clusters <- array(NA, dim=c(nr_of_rows[mod], quant_nr))
      for (p in 1:(quant_nr-1)) {
        clusters[,p] <- PotACs_with_clusters[[mod+p]]$cluster
    }
    PotACs_with_clusters_all_percentiles[[mod]] <- cbind(PotACs_with_clusters[[mod]], clusters)
  }
  
  # Joining data.frames nested in the list PotACs_with_clusters_all_percentiles:
  PotACs_with_clusters_all_percentiles_df <- do.call(rbind.data.frame, PotACs_with_clusters_all_percentiles)
  
  colnames(PotACs_with_clusters_all_percentiles_df) <-
    c("modname","period","ind_lon1","ind_lon2","coord_lon1","coord_lon2",
      "corr","ind_lat1","ind_lat2","coord_lat1","coord_lat2",
      "cluster_p2_5","cluster_p5","cluster_p7_5","cluster_p10",
      "cluster_p12_5","cluster_p15","cluster_p17_5","cluster_p20",
      "cluster_p22_5","cluster_p25","cluster_p27_5","cluster_p30",
      "cluster_p32_5","cluster_p35","cluster_p37_5","cluster_p40",
      "cluster_p42_5","cluster_p45","cluster_p47_5","cluster_p50",
      "cluster_p52_5","cluster_p55","cluster_p57_5","cluster_p60",
      "cluster_p62_5","cluster_p65","cluster_p67_5","cluster_p70",
      "cluster_p72_5","cluster_p75","cluster_p77_5","cluster_p80",
      "cluster_p82_5","cluster_p85","cluster_p87_5","cluster_p90",
      "cluster_p92_5","cluster_p95","cluster_p97_5")
  
  # # Saving PotACs with clusters in csv files:
  write.table(x=PotACs_with_clusters_all_percentiles_df, file=paste0(path_main_output_files,simulation,"_",time_periods[peri]
  ,"_DJF_Ps_pot_AC_30y_new_algorithm_ALL_PERCENTILES_WIDE.csv"), row.names=FALSE, sep=";")
}


######### STORING DATA IN ONE FILEONE FILE PER TIME PERIODS: LONG FORMAT #########

for(peri in 1:peri_nr) {
  # Open files which contain the potential action centers (PotACs) and the associated clusters and join them:
  file_PotACs_with_clusters <- Sys.glob(file.path(paste0(path_PotACs_with_cluster,"*",time_periods[peri],"*")))
  
  # Reading files into the R:
  PotACs_with_clusters <- lapply(file_PotACs_with_clusters, function(x) read.table(x, sep=";", header=TRUE))
  
  # Joining data.frames nested in the list PotACs_with_clusters_all_percentiles:
  PotACs_with_clusters_all_percentiles <- do.call(rbind.data.frame, PotACs_with_clusters)
  
  # Determining the number of rows in each PotAC file:
  nr_of_rows <- as.numeric(lapply(PotACs_with_clusters, nrow))
  # nr_of_rows <- unique(nr_of_rows)
  
  # Adding percentiles as a column:
  repeated_percentiles <- list(NA)
  
  for(i in seq(1,length(nr_of_rows),quant_nr)) {
    repeated_percentiles[[i]] <- rep(pm_quant, times=nr_of_rows[i:(i+38)])
  }
  
  repeated_percentiles <- as.numeric(unlist(repeated_percentiles))
  
  PotACs_with_clusters_all_percentiles_LONG <- cbind(PotACs_with_clusters_all_percentiles, repeated_percentiles)
  
  # Saving PotACs with clusters in csv files:
  write.table(x=PotACs_with_clusters_all_percentiles_LONG, file=paste0(path_main_output_files,simulation,"_",time_periods[peri],
  "_DJF_Ps_pot_AC_30y_new_algorithm_ALL_PERCENTILES_LONG.csv"), row.names=FALSE, sep=";")
}
