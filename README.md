# covid-19-afterwardz

### This script will: 

 Download the most recent Covid-19 data from the [NYT](https://github.com/nytimes/covid-19-data) \
 Open an ODBC channel to the afterwardz covid database \
 Determine the most recent record in the database \
 Add any new records \
 Log results to a file \
 Separate log for serious errors \
 Email admin if failure to update or if duplicates are detected (Not Implemented) \
 Run on a daily basis (Task Scheduler) \
