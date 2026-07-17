# This file creates Time of Day Speed information from the NPMRDS INRIX Datasets
# It summarizes each monthly dataset individually by year
# Created by Puget Sound Regional Council Staff

import pandas as pd
import time
import os
import shutil
import zipfile
import getpass

# Get the inputs passed from the system argument
analysis_months = ['apr']
analysis_year = ['2026']
# analysis_year = ['2018', '2019', '2020', '2021', '2022', '2023', '2024','2025', '2026']
vehicles = 'cars'
input_percentile = 0.95

#define working folders
working_path = os.getcwd()
data_directory = 'C:\\Users\\chelmann\\Puget Sound Regional Council\\2026-2050 RTP Trends - General\\Congestion\\data'
temp_path = os.path.join('c:\\Users',getpass.getuser(),'Downloads')

# Speed Thresholds
low_spd = 5
high_spd = 90

# Dictionary Defining the Start and End Times for the Periods of Analysis
time_of_day = {"TOD_Name":['Overnight','AM Peak','Midday','PM Peak','Late Evening'],
               "start_time":[0,6,10,15,19],
               "end_time":[6,10,15,19,23]
           }
                                                              
# Function to Return the Timeperiod Travel Time
def travel_time(tod, df_timeperiod, average_per):

    # Calculate average observed and reference speeds
    df_avg = df_timeperiod.groupby('Tmc').quantile(average_per)    
    df_avg = df_avg.reset_index()
  
    # Calculate the ratio of observed to reference speed 
    df_avg[tod+'_ratio'] = df_avg['speed'] / df_avg['reference_speed']

    # Rename columns for cleaner output
    df_avg  = df_avg.rename(columns={'speed':tod+'_speed'})
    df_avg = df_avg.drop(['reference_speed'], axis=1)
 
    return df_avg

# The next section is the main body for script execution
start_of_production = time.time()

# Convert the Travel Time percentile to the appropiate value for a pandas calculation
speed_percentile = 1 - input_percentile

# loop over the year to be analyzed
for year in analysis_year:
    
    for months in analysis_months:
        
        print ('Working on Travel Speed calculation for ' + months + ' ' + year + ' ' + vehicles + ' tmc records')
        
        print('Create the output directory for the speed results if it does not already exist')
        output_directory = os.path.join(working_path, 'outputs', 'congestion', months)
        if not os.path.exists(output_directory):
            os.makedirs(output_directory)

        print('Copy the compressed files to the users download directory for quicker processing')
        if os.path.exists(temp_path + '\\' + months + '-' + year + '-' + vehicles + '.zip'):
            os.remove(temp_path + '\\' + months + '-' + vehicles + '-' + year + '.zip')

        shutil.copyfile(data_directory + '\\' + months + '-' + year + '-' + vehicles + '.zip', temp_path + '\\' + months + '-' + year + '-' + vehicles + '.zip')
        npmrds_archive = zipfile.ZipFile(temp_path + '\\' + months + '-' + year + '-' + vehicles + '.zip', 'r')
        npmrds_archive.extractall(temp_path)
        npmrds_archive.close()
        os.remove(temp_path + '\\' + months + '-' + year + '-' + vehicles + '.zip')

        print('Reading in the unzipped data file')
        data_file = os.path.join(temp_path + '\\' + months + '-' + year + '-' + vehicles + ".csv") 
        tmc_id_file = os.path.join(temp_path + '\\' + 'TMC_Identification.csv')
        contents_file = os.path.join(temp_path + '\\' + 'Contents.txt')

        print ('Loading the ' + months + ' ' + year + ' ' + vehicles + ' TMC file into a Pandas Dataframe')
        df_working_tmc = pd.read_csv(tmc_id_file)
        df_working_tmc  = df_working_tmc.rename(columns={'tmc':'Tmc'}) 
       
        print('Trimming columns in working TMC file')
        keep_columns = ['Tmc','county', 'miles', 'f_system', 'thrulanes_unidir']
        df_working_tmc = df_working_tmc.loc[:,keep_columns]

        print ('Loading the ' + months + ' ' + year + ' ' + vehicles + ' Speed file into a Pandas Dataframe')
        df_current_spd = pd.read_csv(data_file)
        df_current_spd  = df_current_spd.rename(columns={'tmc_code':'Tmc'})
        df_current_spd['measurement_tstamp'] = pd.to_datetime(df_current_spd['measurement_tstamp'])
                      
        print ('Removing outliers from the ' + months + ' ' + year + ' ' + vehicles + ' Speed file')
        df_current_spd = df_current_spd[df_current_spd.speed > low_spd]
        df_current_spd = df_current_spd[df_current_spd.speed < high_spd]
        
        print('Creating a Weekday dataframe from the ' + months + ' ' + year + ' ' + vehicles + ' Speed file')
        df_current_spd['day_of_week'] = df_current_spd['measurement_tstamp'].dt.dayofweek
        df_current_spd['day'] = df_current_spd['measurement_tstamp'].dt.day_name()
        
        df_weekdays =  df_current_spd[df_current_spd.day_of_week < 5]
        df_weekdends =  df_current_spd[df_current_spd.day_of_week >= 5]
                           
        # Delete the uncompressed files
        print ('Deleting the temporary ' + months + ' ' + vehicles + ' working files')
        os.remove(data_file)
        os.remove(tmc_id_file)
        os.remove(contents_file)

        # loop over time periods
        print('Working on Weekday Averages')
        for x in range(0,len(time_of_day['TOD_Name'])):

            print ('Calculating Speed Ratios for ' + str(time_of_day['TOD_Name'][x])+ ' ' + year + ' ' + vehicles + ' tmcs')
            df_tod = df_weekdays[df_weekdays['measurement_tstamp'].dt.hour >= time_of_day['start_time'][x]]
            df_tod = df_tod[df_tod['measurement_tstamp'].dt.hour < time_of_day['end_time'][x]]
            keep_columns = ['Tmc','reference_speed','speed']
            df_tod = df_tod.loc[:,keep_columns]
            df_spd = travel_time(time_of_day['TOD_Name'][x], df_tod , speed_percentile)
        
            if x == 0:
                df_output = df_working_tmc
                df_output = pd.merge(df_output, df_spd, on='Tmc', suffixes=('_x','_y'), how='left')
                
            else: 
                df_output = pd.merge(df_output, df_spd, on='Tmc', suffixes=('_x','_y'), how='left')
    
        df_output.to_csv(os.path.join(output_directory, months + '_' + year + '_' + vehicles +'_tmc_'+str(int(input_percentile*100))+'th_percentile_speed_weekdays.csv'),index=False)
            
        print('Working on Weekend Averages')
        for x in range(0,len(time_of_day['TOD_Name'])):

            print ('Calculating Speed Ratios for ' + str(time_of_day['TOD_Name'][x])+ ' ' + year + ' ' + vehicles + ' tmcs')
            df_tod = df_weekdends[df_weekdends['measurement_tstamp'].dt.hour >= time_of_day['start_time'][x]]
            df_tod = df_tod[df_tod['measurement_tstamp'].dt.hour < time_of_day['end_time'][x]]
            keep_columns = ['Tmc','reference_speed','speed']
            df_tod = df_tod.loc[:,keep_columns]
            df_spd = travel_time(time_of_day['TOD_Name'][x], df_tod , speed_percentile)
            
            if x == 0:
                df_output = df_working_tmc
                df_output = pd.merge(df_output, df_spd, on='Tmc', suffixes=('_x','_y'), how='left')
                
            else: 
                df_output = pd.merge(df_output, df_spd, on='Tmc', suffixes=('_x','_y'), how='left')
        
            # Write out the vehicle specific dataframe to csv if desired
            df_output.to_csv(os.path.join(output_directory, months + '_' + year + '_' + vehicles +'_tmc_'+str(int(input_percentile*100))+'th_percentile_speed_weekends.csv'),index=False)
    
end_of_production = time.time()
print ('The Total Time for all processes took', (end_of_production-start_of_production)/60, 'minutes to execute.')