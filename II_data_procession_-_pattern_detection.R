##############################################################
############ DETECTION OF TELECONNECTION PATTERNS ############
##############################################################

######### INPUT DATA #########

### Required R packages:
library(fields)
library(RColorBrewer)
library(maps)
library(mapproj)

# Set the path of the functions:
path_functions <- "D:/.../"

# Set the path of the RDS files which contain the arrays of strongest negative correlations (SNCs)
# created by 01_function_-_computing_absolute_minimum_correlations.R:
# (Example can be found in the script I_data_procession_-_computing_&_plotting_absmincors_&_Finding_PotACs.R.)
path_absmincors <- "D:/.../"

# Set the path of potential action centers (PotACs)
# created by 01_function_-_computing_absolute_minimum_correlations.R:
path_potACs <- "D:/.../"

# Set the path of the cluster patterns (CPs) which will created by this script:
path_RDS <- "D:/.../"

# Set the path of the CP maps:
path_CP_maps <- "D:/.../"

# Set the quantiles (percentiles/100):
sequence_of_quantiles <- seq(0.025,0.975,0.025)

### Loading functions:
source(paste0(path_functions,"04_function_-_pattern_detector.R"))
source(paste0(path_functions,"05_function_-_pattern_connector.R"))
source(paste0(path_functions,"02_function_-_creating_Cartesian_maps.R"))
       
# Examining simulation(s), model(s) and time period(s):
simulation <- "RCP_4.5"
modname <- c("GCM1") # you can add further models to the list
period  <- c("2006-2035") # you can add further time series to the list

# Vectors of latitudes & longitudes (to plot clusters):
lat <- seq(0,90,2.5)
lon <- seq(-180,177.5,2.5)

colorscale <- c("white", "#c896ff", "#ff9664", "#64ffc8", "#6496ff", 
                "#fcbbef", "lightgoldenrod1", "lightpink", "lightsteelblue1","grey60","grey40","grey20")


######### DETECTING CLUSTER PATTERNS #########

modname2 <- rep(modname, each=length(period))         # It is useful if two or more models are examined.
period2 <- rep(period, times=length(unique(modname))) # It is useful if two or more models are examined.

# Quantile below the correlations are examined:
for (mod in 1:length(modname2)) {
for (pm_quant in sequence_of_quantiles) {
  
  # Loading the SNC field:
  absmincor <- readRDS(paste0(path_absmincors, modname2[mod],"_", period2[mod],"_", simulation,"_DJF_del31_daymean_z500_2.5dg.RDS"))
  absmincor <- t(absmincor)

  # Loading the PotACs:
  file_potAC <- paste0(path_potACs, simulation,"_", modname2[mod], "_", period2[mod], "_DJF_Ps_pot_AC_30y_new_algorithm.csv")
  pot_AC <- read.table(file_potAC, sep=";", header=TRUE)
  
  # Set the number of iteration:
  iter <- 3 # Clustering is running three-times to join all neighboring clusters.
  
  # Categorizing original data:
  quant <- quantile(absmincor, probs=pm_quant)
  print(quant)
  
  # Masking the SNC fields and omit PotACs with an associated correlatiom above quant:
  absmincor[absmincor>quant] <- 0
  absmincor[absmincor<=quant] <- 1

  pot_AC <- pot_AC[pot_AC$corr<=quant,]
    
  # Checking: Are there any pot_ACs on the poles or on the Equator?
  if(min(pot_AC$ind_lat1)==1)  print("PotAC on Equator!")
  if(max(pot_AC$ind_lat1)==37) print("PotAC on North Pole!")
  if(min(pot_AC$ind_lat2)==1)  print("PotAC on Equator!")
  if(max(pot_AC$ind_lat2)==37) print("PotAC on North Pole!")

  # Visually checking the masked SNC fields:
  # windows()
  # image.plot(lon, lat, t(absmincor))
  # title(main=modname2[mod])
  
  # Using function from patternDetector.R:
  patterns_ATL <- patternDetector(absmincor)
  
  # Using function from patternConnector.R:
  patterns_ATL_fix <- patternConnector(patterns_ATL)
  
  patterns_ATL_fix_before_clust <- patterns_ATL_fix
  patterns_ATL_fix_before_clust[patterns_ATL_fix_before_clust>0] <- 1
  
  # Omitting clusters which do not contain PotACs:
  clusters <- NA
  clusters2 <- NA
    for (i in 1:dim(pot_AC)[1]){
      clusters[i] <- patterns_ATL_fix[pot_AC$ind_lat1[i], pot_AC$ind_lon1[i]]
      clusters2[i] <- patterns_ATL_fix[pot_AC$ind_lat2[i], pot_AC$ind_lon2[i]]
    }
   
    clusters_all <- NA
    for (i in 1:dim(pot_AC)[1]){
      clusters_all[i] <- ifelse(clusters[i]<clusters2[i], clusters[i], clusters2[i])
    }
    
    # Clusters of the first and second poles of the PotACs:
    clusters_list  <- sort(unique(as.numeric(clusters)))
    clusters2_list <- sort(unique(as.numeric(clusters2)))
    
    # Clusters which contains PotACs:
    cluster_PotAC_list <- sort(unique(c(clusters_list, clusters2_list)))
  
  for (t in 1:iter)  {
  # Joining clusters (renaming some clusters e.g. f=3, 4 and 15)
          clusters <- c(0)
          clusters2 <- c(0)
          for (p in 1:dim(pot_AC)[1]){
            patterns_ATL_fix[pot_AC$ind_lat1[p],pot_AC$ind_lon1[p]]
            clusters[p]  <- patterns_ATL_fix[pot_AC$ind_lat1[p],pot_AC$ind_lon1[p]]
            clusters2[p] <- patterns_ATL_fix[pot_AC$ind_lat2[p],pot_AC$ind_lon2[p]]
          }
          
          for (k in 1:length(clusters)) {
            for (i in 1:length(lat)) {
              for (j in 1:length(lon)) {
                
          if(patterns_ATL_fix[i,j]==clusters[k]){
            if(clusters[k]<clusters2[k]){
              patterns_ATL_fix[i,j] <- clusters[k]
            }else{
              patterns_ATL_fix[i,j] <- clusters2[k]
            }
          }
          if(patterns_ATL_fix[i,j]==clusters2[k]){
            if(clusters[k]<clusters2[k]){
              patterns_ATL_fix[i,j] <- clusters[k]
            }else{
              patterns_ATL_fix[i,j] <- clusters2[k]
            }
          }
          
        }
      }
    }
    
    vect <- sort(c(unique(as.numeric(patterns_ATL_fix)),unique(cluster_PotAC_list)))
    # Elements which appear twice therefore contain PotACs:
    clusters_with_PotACs <- vect[duplicated(vect)]
    
    # Elements which appear only once therefore not contain PotACs:
    clusters_without_PotACs <- setdiff(unique(vect),vect[duplicated(vect)])
  }
  
  for (k in 1:length(clusters_without_PotACs)){
    for (i in 1:(dim(patterns_ATL_fix)[1])){
      for (j in 1:(dim(patterns_ATL_fix)[2])){
        if(patterns_ATL_fix[i,j] == clusters_without_PotACs[k]){
          patterns_ATL_fix[i,j] <- 0
        }
      }
    }
  }
  
  patterns_ATL_fix_after_clust_orig <- patterns_ATL_fix # original numbers
  
  for (k in 1:length(clusters_with_PotACs)){
      for (i in 1:(dim(patterns_ATL_fix)[1])){
        for (j in 1:(dim(patterns_ATL_fix)[2])){
          if(patterns_ATL_fix[i,j] == clusters_with_PotACs[k]){
             patterns_ATL_fix[i,j] <- (k+6000)}
      }
    }
  }
  
  for (i in 1:(dim(patterns_ATL_fix)[1])){
      for (j in 1:(dim(patterns_ATL_fix)[2])){
        if(patterns_ATL_fix[i,j] == 0){
           patterns_ATL_fix[i,j] <- 6000
      }
    }
  }
  
  # Renumbering clusters which helps to visualize clusters (clusters are numbered from 6000)
  patterns_ATL_fix_after_clust_new <- patterns_ATL_fix 
  
  # Checking clusters:
  clusternumb <- unique(as.numeric(patterns_ATL_fix))
  
  print(paste0("You need ", length(unique(unlist(clusternumb))), " colors on the maps."))
  
  ifelse(length(colorscale)>=length(unique(unlist(clusternumb))),
         "You got enough color in the colorscale vector.", 
         "You do not have enough color in the colorscale vector.")
  
  patterns_ATL_fix_before_clust_verif <- patterns_ATL_fix_before_clust
  patterns_ATL_fix_after_clust_new_verif <- patterns_ATL_fix_after_clust_new
  
  patterns_ATL_fix_before_clust_verif[patterns_ATL_fix_before_clust_verif>0] <- 1
  patterns_ATL_fix_after_clust_new_verif[patterns_ATL_fix_after_clust_new_verif==6000] <- 0
  patterns_ATL_fix_after_clust_new_verif[patterns_ATL_fix_after_clust_new_verif>6000] <- 1
  
  if(max(abs(patterns_ATL_fix_before_clust_verif-
          patterns_ATL_fix_after_clust_new_verif))>0){
      print(paste(modname2[mod],period2[mod]))
  }
  
  start <- 6000
  brks <- start:max((unique(as.numeric(patterns_ATL_fix_after_clust_new))))
  lab_brks <- 0:(length(unique(as.numeric(patterns_ATL_fix_after_clust_new)))-1)
  lab_brks[1] <- "No\ncluster"

  # Visualizing CPs on map with Cartesian projection:
  plottingDataOnMap(file=paste0(path_CP_maps,modname2[mod],"_",period2[mod],"_",simulation,"_cluster_pattern_rect.png"),
                    width=19.5, height=6.8, res=300, ptsize=18,
                    x=lon, y=lat, z=t(patterns_ATL_fix_after_clust_new),
                    x_lab=c("-160°","-120°","-80°","-40°","0°","40°","80°","120°","160°"),
                    y_lab=c("0°","20°","40°","60°","80°"),
                    reverse=FALSE, col_scale_type="discrete", col_scale_type2="custom", 
                    col_nr=length(brks), col_scale=colorscale[1:length(brks)],
                    lab_brks=lab_brks, brks=brks,
                    lat_lines=seq(0,80,20), lon_lines=seq(-160,160,20),
                    lon_primary=seq(-160,160,40), lat_primary=seq(0,80,20),
                    lon_secondary=seq(-160,160,20), lat_secondary=seq(0,80,20),
                    size_axis_x=1.2, size_axis_y=1.2, col_axis_x="grey60", col_axis_y="grey60",
                    col_geo_lines="black", col_borders="grey60",
                    point=TRUE, point_x=c(pot_AC$coord_lon1,pot_AC$coord_lon2),
                    point_y=c(pot_AC$coord_lat1,pot_AC$coord_lat2),
                    point_pch=16, point_size=1, point_col="black",
                    connect_points=TRUE, line_coord_lon1=pot_AC$coord_lon1, line_coord_lon2=pot_AC$coord_lon2,
                    line_coord_lat1=pot_AC$coord_lat1, line_coord_lat2=pot_AC$coord_lat2,
                    line_width=2, line_col="black", contour=FALSE)
  
  # Saving the cluster pattern:
  saveRDS(object=patterns_ATL_fix,
          file=paste0(path_RDS, simulation,"_",modname2[mod],"_",period2[mod],
                      "_DJF_zg500_2.5dg_bil_NH_results_pattern_detection_bw_p",pm_quant*100,"_new.RDS"))
  }
}
    
    
