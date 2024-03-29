# SUMMARY

The scripts of **R_codes_related_to_atmospheric_teleconnections** - created by R (R Core Team, 2022) - are used to validate the general circulation models (GCMs) of the Coupled Model Intercomparison Project (CMIP) with respect to atmospheric teleconnections. Those are compared to reanalyses datasets. The gridded time series of the geopotential height field at the 500 hPa surface level are used for the validation. Only winter months (December, January, February) in the Northern Hemisphere (NH) are examined from 1951.

***The main steps of the analysis are the followings:***<br>
**1. Downloading data**<br>
**2. Preprocessing data:**<br> creating daily averages of the gridded time series, interpolating them to a common 2.5° horizontal grid in the NH; 31st December, 31st January and leap days are omitted<br>
**3. Creating basic fields for the analysis:**<br> the fields of strongest negative correlations, in other words absolute minimum correlations are obtained and potential action centers are determined<br>
**4. Analysing data:** <br>
   (a) Examination of the stabilty patterns <br>
       (published in Kristóf et al. 2020: https://doi.org/10.3390/atmos11070723) <br>
   (b) Examination of the cluster patterns and creating teleconnection indices <br>
       (published in Kristóf et al. 2021: https://doi.org/10.3390/atmos12101236)
 
 
# 1. DOWNLOADING DATA
At first, we get the data which are the basis of the analysis. <br>
Time series of the ERA-20C and ERA5 can be downloaded with the R scripts *downloading_data_ERA-20C.R* and *downloading_data_ERA5.R*.
GCM datasets were obtained from Earth System Grid Federation (ESGF) nodes.


# 2. PREPROCESSING DATA
Preprocession is done by the Climate Data Operator (CDO; Schulzweida, 2019; https://doi.org/10.5281/zenodo.3539275).

# 3. CREATING BASIC FIELDS FOR THE ANALYSIS: OBTAINING THE FIELDS OF STRONGEST NEGATIVE CORRELATIONS (SNCs) & DETECTING POTENTIAL ACTION CENTERS (PotACs)

**An example of data procession can be found in the script *I_data_procession_-_computing_&_plotting_absmincors_&_finding_PotACs.R*.**
Test files can be downloaded from this link: https://ekristof86.web.elte.hu/test_files/

We compute Pearson cross-correlation coefficients (henceforth correlations) between gridded time series for each database by using the script *01_function_-_computing_absolute_minimum_correlations.R*. The correlations are determined based on detrended daily climatology datasets. (The long-term mean is subtracted from each data and those are divided by the long-term standard deviation in each grid cell.) Then, SNCs are obtained in each grid cell. <br>
<br>
Note that the scripts only work on arrays without missing data! <br>
<br>
SNCs can be plotted on maps with Cartesian projection by using the function in *02_function_-_creating_Cartesian_maps.R*.

We obtain the coordinates of the potential action centers (PotACs) by using the script *03_function_-_finding_PotACs.R*.
With that script pairs of grid cells - in other words poles - are detected which have the same correlation value in the SNC field.
The input files are the RDS files created with the script *04_function_-_computing_absolute_minimum_correlations.R*.


# 4. CREATING CLUSTER PATTERNS BASED ON THE SNC FIELDS

**An example of data procession can be found in the script *II_data_procession_-_pattern_detection.R*.**

For that purpose functions are used which can be found in the scripts *04_function_-_pattern_detector.R* and *05_function_-_pattern_connector.R*.
Cluster patterns are visualized on maps with Cartesian projection by using the function in *02_function_-_creating_Cartesian_maps.R*.

By using the script ***III_data_procession_-_associating_clusters_to_the_PotACs.R***, clusters are associated with each PotAC in case of each GCM for each time period and those are stored in csv files. Tables stored in the csv files are merged. Wide and long formats of the merged tables are availabe.

**GCM cluster patterns are compared to the reference cluster pattern by using the script *06_function_-_ROC_and_related_measures.R*.**
Cluster patterns created by the script *II_data_procession_-_pattern_detection.R* are stored in RDS files, i.e. two-dimensional arrays.

