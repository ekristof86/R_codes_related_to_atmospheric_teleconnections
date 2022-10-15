###########################
### COMPUTING VARIANCES ###
###########################

# This script computes variances of daily/monthly climatology (clim) time series where
# the linear trend is removed. The two-dimensional fields of variances are stored in RDS file.
# Additional details (e.g., titles of the input files) are stored in RData file.

# The input fil is a 3-dimensional (3D) arrays (lon x lat x time) in a netCDF file.

# Note that geopotential height (zg) are available in NCEP reanalyses and CMIP5/CMIP6 GCM outputs,
# while geopotential data (z) are available in ERA reanalyses. z can be converted to zg as follows:
# z=zg/9.80665 where 9.80665 is a constant determined by the World Meteorological Organization (WMO).


######### FUNCTION #########
# file: the input file with file path (see above)
# longitude, latitude, time_numeric, time_origin: attributes of the 3D NetCDF files
# variable: atmospheric variable which data are stored in the netCDF files
# modname: name of the model simulation, e.g., "HadGEM2-CC_RCP4_5"
# period: time period, e.g., "1991-2020"
# lon1, lon2, lat1, lat2: choosing area (by giving indices of the first and last latitudes, longitudes)
# check: Personal check of the creator of the function, when daily winter time series
         # are used where December January and February contains 30, 30, 28 data respectively.
         # Please use check==FALSE.
# path: Variances are stored in RData and RDS files in the given directory.
# file_RData, file_RDS: titles of the RData and RDS files

Var_clim <- function(file=file,
                     longitude=longitude, latitude=latitude, time_numeric=time_numeric,
                     time_origin= time_origin, variable=variable,
                     modname=modname, period=period,
                     lon1=lon1, lon2=lon2, lat1=lat1, lat2=lat2,
                     check=FALSE, path=path, file_RData=file_RData, file_RDS=file_RDS) {

  # Requried packages:
  library(ncdf4)  # to handle netCDF files (functions nc_open, ncvar_get, nc_close)
  library(pracma) # to detrend datasets function detrend)
  library(fields) # to create map with colorscale
  library(maps)   # to add country borders to the map
  library(RColorBrewer)  # to create colorbar
  

  ######### I. OPEN THE INPUT FILES AND STORE DATA #########

  ### Opening the NetCDF file and storing its data:
  file.nc <- nc_open(file)
  lon <- ncvar_get(file.nc, longitude)
  lat  <- ncvar_get(file.nc, latitude)
  time  <- ncvar_get(file.nc, time_numeric)
  date <- as.POSIXct(time*3600, origin=time_origin, tz="UTC")
  
  var <- ncvar_get(file.nc, variable)
  var <- var[lon1:lon2,lat1:lat2,]/9.80665
  
  nc_close(file.nc)
  
  # Checking data:
  print("FILE1: Dimensions of the variable, quantiles of the variable:")
  print(dim(var))
  print(quantile(var, na.rm=TRUE))
  print("The first and last six values of the dimensions.")
  print("Longitudes:")
  print(head(lon))
  print(tail(lon))
  print("Latitudes:")
  print(head(lat))
  print(tail(lat))
  print("Dates:")
  print(head(date))
  print(tail(date))
  
  ### Creating detrended climatology datasets:
  var_dc_trend <- array(0,dim=c(length(lon1:lon2),length(lat1:lat2),dim(time)))
  for (p in 1:length(lon1:lon2)) { 
    for (q in 1:length(lat1:lat2)) { 
      var_dc_trend[p,q,] <- detrend(var[p,q,])
    }
  }
  
  
  ######### II. COMPUTING VARIANCES #########
  
  var_table <- array(0,dim=c(length(lon1:lon2),length(lat1:lat2)))
  for(i in 1:dim(lon)) {
    for(j in 1:dim(lat)) {
      var_table[i,j] <- var(var_dc_trend[i,j,])
    }
  }
  
  # Checking range of the data:
  print(range(var_table))
  
 
  ######### III. STORING DATA #########
  
  ### Removing unnecessary objects:
  rm(var,
     var_dc_trend,
     p, q, i, j)
  
  ### Storing data:
  print(paste0("Data will be stored in here: ", path))
  print(paste0("COMPUTATIONS ARE COMPLETED FOR ", modname, " ", period, "."))
  save.image(paste0(path, file_RData))
  saveRDS(object=var_table, file=paste0(path, file_RDS))
  

  return(var_table)
}
