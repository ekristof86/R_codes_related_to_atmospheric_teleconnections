######################################################################################
### COMPUTING CROSS CORRELATIONS AND THE FIELDS OF STRONGEST NEGATIVE CORRELATIONS ###
######################################################################################

# The following code is appropriate to computing cross correlations, creating the fields of
# strongest negative correlations (SNCs), determining potential action centers (PotACs) and
# plotting SNCs with PotACs.

######### INPUT DATA #########

# Set the path of the the following functions:
path_functions <- "D:/.../"

source(paste0(path_functions,"01_function_-_computing_absolute_minimum_correlations.R"))
source(paste0(path_functions,"02_function_-_creating_Cartesian_maps.R"))
source(paste0(path_functions,"03_function_-_finding_PotACs.R"))

# Set the path of the input files:
path <- "D:/.../"

# Titles of the input files: THE TEST FILES ARE AVAILABLE HERE: https://ekristof86.web.elte.hu/test_files/
file_title <- "test_dataset.nc" # the array contains random data which come from standard normal distribution
file_title2 <- "test_dataset_means.nc"
file_title3 <- "test_dataset_stds.nc"

# Set the path of the rds files in which the fields of strongest negative correlations (SNCs) will be stored:
path_SNCs <-  "D:/.../"

# Set the path of the files in which the csv files of potential action centers (PotACs) will be stored:
path_potACs <- "D:/.../"

# Creating lists of file titles:
file <- Sys.glob(file.path(paste0(path, file_title)))   # file(s) which contain(s) gridded time series
file2 <- Sys.glob(file.path(paste0(path, file_title2))) # file(s) which contain(s) the means of the time series in each grid cell
file3 <- Sys.glob(file.path(paste0(path, file_title3))) # file(s) which contain(s) the standard deviations of the time series in each grid cell

# Examining RCP4.5 simulation(s):
# Examining simulation(s), model(s) and time period(s):
simulation <- "RCP_4.5"
modname <- c("GCM") # you can add further models to the list
period  <- c("2006-2035") # you can add further time series to the list

# vectors of latitudes & longitudes (to detect PotACs):
lat <- seq(0,90,2.5)
lon <- seq(-180,177.5,2.5)

modname2 <- rep(modname, each=length(period))         # It is useful if two or more models are examined.
period2 <- rep(period, times=length(unique(modname))) # It is useful if two or more models are examined.


############################################################################
############ CREATING FIELDS OF STRONGEST NEGATIVE CORRELATIONS ############
############################################################################

for (i in 1:length(file)) {
  
  file_RData <- paste0(modname2[i], "_", period2[i], "_", simulation, ".RData")
  file_RDS   <- paste0(modname2[i], "_", period2[i], "_", simulation, ".RDS")
  
  AbsMinCor_clim(file=file[i], file2=file2[i], file3=file3[i],
                 longitude="longitude", latitude="latitude", time_numeric="time",
                 time_origin="0001-01-01", variable="zg",
                 corrtype="pearson", modname=modname2[i], period=period2[i],
                 lon1=1, lon2=144, lat1=1, lat2=37,
                 check=FALSE, path=path_SNCs,
                 file_RData=file_RData, file_RDS=file_RDS,
                 check_miss_val=FALSE)
}


############################################################
############ DETECTING POTENTIAL ACTION CENTERS ############
############################################################

for(i in 1:length(modname2)) {
  # Input array which contains the arrays of the SNCs:
  absmincor <- readRDS(paste0(path_SNCs,modname2[i],"_",period2[i],"_",simulation,".RDS"))
  
  # Object  which will contain the coordinates of the potential action centers (potACs):
  csv_name <- paste0(path_potACs,modname2[i],"_",period2[i],"_",simulation,".csv")
  
  find_potACs(absmincor=absmincor, csv_name=csv_name)
}


##############################################################
### PLOTTING CROSS CORRELATIONS & POTENTIAL ACTION CENTERS ###
##############################################################

rds_files <- Sys.glob(file.path(paste0(path_SNCs,"*.RDS")))

# Only PotACs with stronger negative correlations than corlimit will be plotted:
# corlimit <- quantile(absmincor, probs=c(0.25), na.rm=T)
corlimit <- -0.05
  
for (i in 1:length(rds_files)) {
  data <- readRDS(rds_files[i])

  # Input data.frame which contains coordinates of the PotACs:
  df <- read.table(paste0(path_potACs,modname2[i],"_",period2[i],"_",simulation,".csv"),
                   sep=";", header=TRUE)     
  pot_AC_list <- df[df$corr<=corlimit,]
  
  # Creating the plot:
  plottingDataOnMap(file=paste0(modname2[i],"_",period2[i],".png"),
                    width=19.5, height=6.8, res=300, ptsize=18,
                    x=seq(-180,177.5,2.5), y=seq(0,90,2.5), z=data,
                    x_lab=c("-160°","-120°","-80°","-40°","0°","40°","80°","120°","160°"),
                    y_lab=c("0°","20°","40°","60°","80°"),
                    reverse=TRUE, col_nr=9, col_scale="Blues",
                    lab.brks=c("-0.15","-0.1","-0.05","0"),
                    brks=c(-0.15,-0.1,-0.05,0),
                    lat_lines=seq(0,80,20), lon_lines=seq(-160,160,20),
                    lon_primary=seq(-160,160,40), lat_primary=seq(0,80,20),
                    lon_secondary=seq(-160,160,20), lat_secondary=seq(0,80,20),
                    size_axis_x=1.2, size_axis_y=1.2, col_axis_x="grey60", col_axis_y="grey60",
                    col_geo_lines="black", col_borders="grey60",
                    point=FALSE, point_x=c(df$coord_lon1,df$coord_lon2), point_y=c(df$coord_lat1,df$coord_lat2),
                    point_pch=16, point_size=1, point_col="red",
                    connect_points=FALSE, line_coord_lon1=df$coord_lon1, line_coord_lon2=df$coord_lon2,
                    line_coord_lat1=df$coord_lat1, line_coord_lat2=df$coord_lat2, line_width=2, line_col="red",
                    contour=TRUE, contour_col="black", contour_lwd=2, contour_labcex=1)
}


