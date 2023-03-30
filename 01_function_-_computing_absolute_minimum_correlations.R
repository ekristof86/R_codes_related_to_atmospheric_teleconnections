#################################################
### COMPUTING STRONGEST NEGATIVE CORRELATIONS ###
#################################################

# This script computes cross-correlations between daily/monthly climatology (clim) time series where
# the linear trend is removed. After that fields of strongest negative correlations - in other words
# absolute minimum correlations - are created and # stored in RDS file. Additional details
# (e.g., titles of the input files) are stored in RData file.

# The input files are 3-dimensional (3D) arrays (lon x lat x time) in netCDF files:
                      # the 1st file (file1) contains gridded time series
                         # (e.g., if length(lon)=144, length(lat)=37, length(time)=2640,
                         # then the array contains 144 x 37 x 2640 data),
                      # the 2nd file (file2) contains the means of gridded time series
                         # (e.g., if length(lon)=144, length(lat)=37, length(time)=2640,
                         # then the array contains 144 x 37 data),
                      # the 3rd file (file3) standard deviations of gridded time series
                         # (e.g., if length(lon)=144, length(lat)=37, length(time)=2640,
                         # then the array contains 144 x 37 data),

# The fields of strongest negative correlations are obtained and stored from the arrays of the cross-correlations.
# Note that cross-correlations are not stored.

# Note that geopotential height (zg) are available in NCEP reanalyses and CMIP5/CMIP6 GCM outputs,
# while geopotential data (z) are available in ERA reanalyses. z can be converted to zg as follows:
# z=zg/9.80665 where 9.80665 is a WMO constant. However, this conversion is not necessary in case
# of computing correlations due to its invariance under multiplication.


######### FUNCTION #########
# file1, file2, file3: are input files with file path (see above)
# longitude, latitude, time_numeric, time_origin: attributes of the 3D NetCDF files
# variable: atmospheric variable which data are stored in the netCDF files
# corrtype: pearson (computing Pearson correlations) or spearman (computing Spearman correlations)
# modname: name of the model simulation, e.g., "HadGEM2-CC_RCP4_5"
# period: time period, e.g., "1991-2020"
# lon1, lon2, lat1, lat2: choosing area (by giving indices of the first and last latitudes, longitudes)
# check: Personal check of the creator of the function, when daily winter time series
         # are used where December January and February contains 30, 30, 28 data respectively.
         # Please use check==FALSE.
# path: Absolute minimum correlations are stored in RData and RDS files in the given directory.
# file_RData, file_RDS: titles of the RData and RDS files

AbsMinCor_clim <- function(file=file, file2=file2, file3=file3,
                           longitude=longitude, latitude=latitude, time_numeric=time_numeric,
                           time_origin= time_origin, variable=variable,
                           corrtype=corrtype, modname=modname, period=period,
                           lon1=lon1, lon2=lon2144, lat1=lat1, lat2=lat2,
                           check=FALSE, path=path, file_RData=file_RData, file_RDS=file_RDS,
                           check_miss_val=FALSE) {

  # Requried packages:
  library(ncdf4)  # to handle netCDF files (functions nc_open, ncvar_get, nc_close)
  library(pracma) # to detrend datasets function detrend)
  library(Hmisc)  # to computing cross-correlations in a very effective way (function rcorr)
  library(fields) # to create map with colorscale
  library(maps)   # to add country borders to the map
  library(RColorBrewer)  # to create colorbar
  

  ######### I. OPEN THE INPUT FILES AND STORE DATA #########

  ### Opening original NetCDF files and storing their data:
  file.nc <- nc_open(file)
  lon <- ncvar_get(file.nc, longitude)
  lat  <- ncvar_get(file.nc, latitude)
  time  <- ncvar_get(file.nc, time_numeric)
  date <- as.POSIXct(time*3600, origin=time_origin, tz="UTC")
  
  var <- ncvar_get(file.nc, variable)
  var <- var[lon1:lon2,lat1:lat2,]
  
  nc_close(file.nc)
  
  # Checking data:
  print("FILE1: Dimensions of the variable, quantiles of the variable:")
  print(dim(var))
  # Checking for missing values:
  if(check_miss_val==TRUE) {
    if(is.na(min(var))) stop("Error! There is missing data in this array.")
  }
  
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
  
  # Opening netCDF files with daily means:
  file_dc.nc <- nc_open(file2)
  lon_dc <- ncvar_get(file_dc.nc, longitude)
  lat_dc <- ncvar_get(file_dc.nc, latitude)
  time_dc <- ncvar_get(file_dc.nc, time_numeric)
  date_dc <- as.POSIXct(time_dc*3600, origin=time_origin, tz="UTC")
  var_dc <- ncvar_get(file_dc.nc, variable)
  var_dc <- var_dc[lon1:lon2,lat1:lat2,]
  
  nc_close(file_dc.nc)
  
  # Checking data:
  print("FILE2: Dimensions of the variable, quantiles of the variable:")
  print(dim(var_dc))
  # Checking for missing values:
  if(check_miss_val==TRUE) {
    if(is.na(min(var_dc))) stop("Error! There is missing data in this array.")
  }
  
    print(quantile(var_dc, na.rm=TRUE))
  print("The first and last six values of the dimensions.")
  print("Longitudes:")
  print(head(lon_dc))
  print(tail(lon_dc))
  print("Latitudes:")
  print(head(lat_dc))
  print(tail(lat_dc))
  print("Dates:")
  print(head(date_dc))
  print(tail(date_dc))
  
  # Opening netCDF files with daily standard deviations:
  file_dc_sd.nc <- nc_open(file3)
  lon_dc_sd <- ncvar_get(file_dc_sd.nc, longitude)
  lat_dc_sd <- ncvar_get(file_dc_sd.nc, latitude)
  time_dc_sd <- ncvar_get(file_dc_sd.nc, time_numeric)
  date_dc_sd <- as.POSIXct(time_dc_sd*3600, origin=time_origin, tz="UTC")
  var_dc_sd <- ncvar_get(file_dc_sd.nc, variable)
  var_dc_sd <- var_dc_sd[lon1:lon2,lat1:lat2,]

  nc_close(file_dc_sd.nc)
  
  # Checking data:
  print("FILE3: Dimensions of the variable, quantiles of the variable:")
  print(dim(var_dc_sd))
  # Checking for missing values:
  if(check_miss_val==TRUE) {
    if(is.na(min(var_dc_sd))) stop("Error! There is missing data in this array.")
  }
  print(quantile(var_dc_sd, na.rm=TRUE))
  
  print("The first and last six values of the dimensions.")
  print("Longitudes:")
  print(head(lon_dc_sd))
  print(tail(lon_dc_sd))
  print("Latitudes:")
  print(head(lat_dc_sd))
  print(tail(lat_dc_sd))
  print("Dates:")
  print(head(date_dc_sd))
  print(tail(date_dc_sd))
  
  
  ######### II. COMPUTING CLIMATOLOGY TIME SERIES #########
  
  ### Creating climatology time series:
  var_anom_dc <- array(NA, dim=c(length(lon1:lon2),length(lat1:lat2),dim(time)))
  for (i in 1:length(lon1:lon2)) {
    for (j in 1:length(lat1:lat2)) {
      for (n in 1:dim(time_dc)) {
        for (k in seq(n,dim(time),dim(time_dc))) {
          var_anom_dc[i,j,k] <- (var[i,j,k]-var_dc[i,j,n])/var_dc_sd[i,j,n]
        }
      }
    }
  }
  
  # Checking data (absolute value of the differences shall be 0):
  
  if(check==TRUE){
    # E.g., on jan. 30, in the last grid cell:
    print(max(abs(((var[dim(lon),dim(lat),format(date,"%m")=="01"&format(date,"%d")=="30"]-var_dc[dim(lon),dim(lat),30])/var_dc_sd[dim(lon),dim(lat),30]) - var_anom_dc[dim(lon),dim(lat),seq(30,dim(time),88)])))
    # E.g., on dec. 1, in the first grid cell:
    print(max(abs(((var[1,1,format(date,"%m")=="12"&format(date,"%d")=="01"]-var_dc[1,1,59])/var_dc_sd[1,1,59]) - var_anom_dc[1,1,seq(59,dim(time),88)])))
    print("If the difference is not 0, then some error could be occured.")
  }
  
  ### Creating detrended climatology datasets:
  var_dc_trend <- array(NA,dim=c(length(lon1:lon2),length(lat1:lat2),dim(time)))
  for (p in 1:length(lon1:lon2)) { 
    for (q in 1:length(lat1:lat2)) { 
      var_dc_trend[p,q,] <- detrend(var_anom_dc[p,q,])
    }
  }
  
  # Checking data:
  print("FILE3: The quantiles of the detrended climatology datasets:")
  print(quantile(var_dc_trend, na.rm=TRUE))

  ######### III. COMPUTING CROSS-CORRELATIONS & STRONGEST NEGATIVE CORRELATIONS #########
  
  # Converting the three-dimensional array to table:
  table <- t(matrix(data=var_dc_trend, nrow=dim(lon)*dim(lat), ncol=dim(time)))
  
  # Rows indicate times while columns indicate grid cells:
  # in the first column: lat1xlon1, lat1xlon2, ..., lat1xlon144
  # in the last column: lat37xlon1, lat37xlon2, ..., lat25xlon144
  
  corrs <- rcorr(table, type=corrtype)
  
  # Obtaining strongest negative correlations (absolute minimum correlations)
  absmincorrs <- apply(corrs$r, 1, FUN=min)
  absmincorrs_table <- matrix(absmincorrs, nrow=dim(lon), ncol=dim(lat)) 
  
  # Checking range of the data:
  print(range(absmincorrs_table))
  
 
  ######### IV. STORING DATA #########
  
  ### Removing unnecessary objects:
  rm(var, var_dc, var_anom_dc, var_dc_sd,
     var_dc_trend, lon_dc, lat_dc, time_dc, date_dc, file.nc, file_dc.nc, file_dc_sd.nc,
     time_dc_sd, date_dc_sd, i, j, n, p, q, corrs, absmincorrs)
  
  ### Storing data:
  print(paste0("Data will be stored in here: ", path))
  print(paste0("COMPUTATIONS ARE COMPLETED FOR ", modname, " ", period, "."))
  save.image(paste0(path, file_RData))
  saveRDS(object=absmincorrs_table, file=paste0(path, file_RDS))
  

  return(absmincorrs_table)
}
