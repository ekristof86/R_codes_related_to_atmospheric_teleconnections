# MAIN PURPOSE OF THE CODES

The scripts of R_codes_related_to_atmospheric_teleconnections are used to validate CMIP GCMs with respect to atmospheric teleconnections by comparing them to reanalyses datasets.
The gridded time series of the geopotential height field at the 500 hPa surface level is used for the validation. Only winter months over the Northern Hemisphere
(December, January, February) are examined from 1951.

The main steps of the analysis are the followings:
1. Downloading data
2. Preprocessing data: creating daily averages of the gridded time series, interpolating them to a common 2.5° horizontal grid
3. Creating basic fields - i.e. fields of strongest negative correlations - for the analysis
4. Analysing data: <br>
   (a) Examination of the stabilty patterns <br>
       (published in Kristóf et al. 2020: https://doi.org/10.3390/atmos11070723) <br>
   (b) Examination of the cluster patterns and creating teleconnection indices <br>
       (published in Kristóf et al. 2021: https://doi.org/10.3390/atmos12101236)
 
# DOWNLOADING DATA
First, we get the data which are the basis of the analysis. <br>
Data of ERA-20C and ERA5 are downloaded with the R scripts downloading_data_ERA-20C.R and downloading_data_ERA5.R.
