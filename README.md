# MAIN PURPOSE OF THE CODES

The scripts of R_codes_related_to_atmospheric_teleconnections - created by R (R Core Team, 2022) are used to validate CMIP GCMs with respect to atmospheric teleconnections by comparing them to reanalyses datasets. The gridded time series of the geopotential height field at the 500 hPa surface level is used for the validation. Only winter months (December, January, February) in the Northern Hemisphere (NH) are examined from 1951.

The main steps of the analysis are the followings:
1. Downloading data
2. Preprocessing data: creating daily averages of the gridded time series, interpolating them to a common 2.5° horizontal grid in the NH; 31st December, 31st January and leap days are omitted
3. Creating basic fields - i.e. fields of strongest negative correlations, in other words absolute minimum correlations - for the analysis
4. Analysing data: <br>
   (a) Examination of the stabilty patterns <br>
       (published in Kristóf et al. 2020: https://doi.org/10.3390/atmos11070723) <br>
   (b) Examination of the cluster patterns and creating teleconnection indices <br>
       (published in Kristóf et al. 2021: https://doi.org/10.3390/atmos12101236)
 
# 1. DOWNLOADING DATA
At first, we get the data which are the basis of the analysis. <br>
Data of ERA-20C and ERA5 are downloaded with the R scripts downloading_data_ERA-20C.R and downloading_data_ERA5.R.

# 2. PREPROCESSING DATA
Preprocession is done by Climate Data Operator (CDO; Schulzweida, 2019; https://doi.org/10.5281/zenodo.3539275).

# 3. CREATING BASIC FIELDS FOR THE ANALYSIS: OBTAINING THE FIELDS OF STRONGEST NEGATIVE CORRELATIONS (SNCs)
We compute Pearson cross-correlation coefficients (henceforth correlations) between gridded time series for each database by using the script function_computing_absolute_minimum_correlations.R. The correlations are determined based on detrended daily climatology datasets. (The long-term mean is subtracted from each data and those are divided by the long-term standard deviation in each grid cell.) Then, SNCs are obtained in each grid cell. <br>
<br>
Note that the scripts only work on arrays without missing data! <br>
<br>
SNCs can be plotted on maps with Cartesian projection by using the function in plot_creating_Cartesian_maps.R.

# 4. FINDING POTENTIAL ACTION CENTERS
We obtain the coordinates of the potential action centers (PotACs) by using the script function_-_finding_PotACs.R.
With that script pairs of grid cells - in other words poles - are detected which have the same correlation value in the strongest negative correlation field.
The input files are the RDS files created with the script function_-_computing_absolute_minimum_correlations.R.
