###########################################
###### DOWNLOAD ERA-20C NETCDF FILES ######
###########################################

######### BASIC INFORMATION #########

# Further details about ERA-20C can be found in:
# Poli, P., Hersbach, H, Dee, D.P., Berrisford, P., Simmons, A.J., Vitart, F., Laloyaux, P.,
# Tan, D.G.H., Peubey, C., Thepaut, J-N., Tremolet, Y., Holm, E.V., Bonavita, M., Isaksen, L.,
# Fisher, M. ERA-20C: An Atmospheric Reanalysis of the Twentieth Century.
# Journal of Climate, 29, 4083-4097, https://doi.org/10.1175/JCLI-D-15-0556.1

# For the download the functions of the ecmwfr R package are used:
# Hufkens, Stauffer and Campitelli (2019). The ecwmfr package: an interface to
# ECMWF API endpoints https://doi.org/10.5281/zenodo.2647541

# In the example of this script 3 hourly 500 hPa geopotential data can be
# downloaded for January 2010 from the ERA5 reanalysis on a 2.5x2.5 horizontal grid.

### Required package ###
library(ecmwfr) # In order to download ERA-20C data in R in NetCDF file format


######### PARAMETERS #########
# user:       username (e-mail)
# key:        API key at ECMWF
              # note that to download ERA ECMWF registration and API key are required
              # at the following website: https://apps.ecmwf.int/registration/
# fileDir:    Where to download data?
# lon1, lon2: geographical longitude of the selected grid point (negative values: W, positive values: E)
              # (between -180 and 180)
# lat1, lat2: geographical latitude of the selected grid point (negative values: S, positive values: N)
              # (between -90 and 90)
# startDate:  start year of the downloading data
# endDate:    end year of the downloading data
# hourList:   list of hours in a day
# gridRes:    resolution of the grid
# timeOut:    the time interval to wait for the server in seconds

# Please fill the followings (...) with your ID (e-mail), API key and file path:
userID <- wf_set_key(user = "...",
                     key = "...",
                     service = "webapi")

fileDir <- "..."
# e.g. "C:/Users/Documents"

lon1 <- -180  # W
lon2 <- 177.5 # E
lat1 <- 0     # S
lat2 <- 90    # N

startDate <- "2010-01-01"
endDate   <- "2010-01-31"

gridRes <- paste0(2.5,"/",2.5)

hourList <- c("00:00","03:00","06:00","09:00","12:00","15:00","18:00","21:00")
  
timeOut <- 10800


######### REQUEST #########

request <- list(
    "dataset" = "era20c",
    "class" = "ea",
    "expver" = "1",
    "stream" = "oper",
    "type" = "an",
    "levtype" = "pl",
    "levelist" = "500",
    "param" = "129.128",
    "date" = paste0(startDate, "/to/", endDate), 
    "time" = hourList,
    "area" = paste0(lat1,"/",lon1,"/",lat2,"/",lon2), # N, W, S, E
    "grid" = gridRes,
    "format" = "netcdf",
    "target" = paste0("ERA-20C_z500_",startDate,"-",endDate,".nc"))
    
    file <- wf_request(user     = userID,
                       request  = request,
                       transfer = TRUE,
                       path     = fileDir,
                       time_out = timeOut)

### COMMENTS ###
# If surface data are required then "levtype" = "sfc" could be used
# and parameters "levtype" = "pl" and "levelist" = "500" shall be omitted.

# The names of the variables 2 m temperature
# and mean sea level pressure are "167.128" and 151.128.
    
# In case of total precipitation "type"="fc" shall be used because the type 
# of this variable is forecast, not analysis. The name of the variable is 228.128.
# Instead of the time parameter, the step parameter can be used.
# Precipitation is accumulated from 06 UTC. E.g. "step"="24".
