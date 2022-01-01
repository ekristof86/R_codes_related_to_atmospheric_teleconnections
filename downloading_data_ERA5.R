############################################
######## DOWNLOAD ERA5 NETCDF FILES ########
############################################

######### BASIC INFORMATION #########

# Further details about ERA5 can be found in:
# Hersbach, H, Bell, B, Berrisford, P, et al. The ERA5 global reanalysis.
# Q J R Meteorol Soc. 2020; 146: 1999– 2049. https://doi.org/10.1002/qj.3803

# For the download the functions of the ecmwfr R package are used:
# Hufkens, Stauffer and Campitelli (2019). The ecwmfr package: an interface to
# ECMWF API endpoints https://doi.org/10.5281/zenodo.2647541

# In the example of this script 3 hourly 500 hPa geopotential data can be
# downloaded for December, January and February between 1981 and 2020
# from the ERA5 reanalysis, on a 2.5x2.5 horizontal grid.

### Required package ###
library(ecmwfr) # In order to download ERA5 data in R in NetCDF file format


######### PARAMETERS #########
# user:       user ID at Copernicus
# key:        API key at Copernicus
              # note that to get user ID and API key Copernicus registration is
              # required at the following website: https://cds.climate.copernicus.eu/#!/home
# fileDir:    Where to download data?
# lon1, lon2: geographical longitude of the selected grid point (negative values: W, positive values: E)
              # (between -180 and 180)
# lat1, lat2: geographical latitude of the selected grid point (negative values: S, positive values: N)
              # (between -90 and 90)
# startYear:  start year of the downloading data
# endYear:    end year of the downloading data
# monthList:  list of months
# dayList:    list of days in a month
# hourList:   list of hours in a day
# gridRes:    resolution of the grid
# dataBase:   the title of the ERA5 database
# timeOut:    the time interval to wait for the server in seconds

# Please fill the followings (...) with your ID, API key and file path:
userID <- wf_set_key(user = "...",
                     key = "...",
                     service = "cds")

fileDir <- "..."
# e.g. "C:/Users/Documents"

lon1 <- -180  # W
lon2 <- 177.5 # E
lat1 <- 0     # S
lat2 <- 90    # N

startYear <- 1981
endYear   <- 2020

monthList <- c("01","02","12") # only winters
  
dayList <- c("01","02","03","04","05","06","07","08","09","10",
             "11","12","13","14","15","16","17","18","19","20",
             "21","22","23","24","25","26","27","28","29","30","31")
  
hourList <- c("00:00","03:00","06:00","09:00","12:00","15:00","18:00","21:00")
  
timeOut <- 10800

gridRes <- paste0(2.5,"/",2.5)

dataBase <- "reanalysis-era5-pressure-levels" # from 1979 to present
# "reanalysis-era5-pressure-levels-preliminary-back-extension" # between 1950 and 1978


######### REQUEST #########

request <- list(
    "dataset_short_name" = dataBase,
    "class" = "ea",
    "expver" = "1",
    "stream" = "oper",
    "product_type" = "reanalysis",
    "pressure_level" = "500",
    "variable" = "geopotential",
    "year" = as.character(startYear:endYear),
    "month" = monthList,
    "day" = dayList,
    "time" = hourList,
    "area" = paste0(lat1,"/",lon1,"/",lat2,"/",lon2), # N, W, S, E
    "grid" = gridRes,
    "format" = "netcdf",
    "target" = paste0("ERA5_z500_",startYear,"-",endYear,"_NH.nc"))
    
    file <- wf_request(user     = userID,
                       request  = request,
                       transfer = TRUE,
                       path     = fileDir,
                       time_out = timeOut)

### COMMENTS ###
# If surface data are required then "levtype" = "sfc" could be used
# instead of "pressure_level" = "500".

# The names of the variable in case of air pressure, 2m temperature and precipitation are:
# "surface_pressure", "2m_temperature" and "total_precipitation".
    
# If older versions of the ecmwfr package are used then "dataset"
# shall be used as parameter name instead of "dataset_short_name".      
