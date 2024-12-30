# Bike_sharing
I analyzed a bike sharing data set to understand the difference in behaviours of casual riders and member riders. From there, I gave recommendation on how to convert casual riders to member  
※2024/12/27  
■ Tool used: Microsoft SQL, later BigQuery  
■ Steps taken:   
  〇　Preparation  
	・Downloaded data: 12 months of data, from 2023/12 to 2024/11  
	・Converted files to xls, using Save as feature  
	・Imported .xls files into SQL, using SQL Server Import and Export Wizard  
	・Changed to BigQuery  
	・Used Google Cloud Storage to store files bigger than 100MB  
	・Created combined_data, totaling 5,906,269 rows, 13 columns  
  〇　Clean  
	・Saved raw data files as csv files locally  
	・Removed duplicates: none found  
	・Removed null data rows: 1,661,547 rows found. 4244722 rows left  
	・Removed irrelevant data: none found  
  〇 Analysis  
	・Split datetime to date and time, add 4 new columns for start and end date and time  
	・Delete the original datetime columns  
	・Count bike trips for each hour, for members and casuals together and separately  

■ Problems encountered  and solutions  
	1/ Manually converting 14 csv files to xls files, and import each of them into SQL took too much time.  
	2/ SQL server imported and interpreted data type of the same columns in different table differently, leading to difficulties in combining all the tables  
	3/ To solve problem 2, I changed to BigQuery. But new problem occurred: file limited to 100MB. I used Google Cloud storage to upload the file   

※2024/12/28  
■ Tool used: BigQuery, Tableau  

■ Steps taken:   
  〇 Analysis  
	・Calculated average duration, total duration for bike trips. Added a duration_min column, totaling 18 columns  
	・Found the top 10 busiest routes  
	・Calculated the average duration  
	・Found the busiest month  
	・Found the busiest day of a week  
	・Found top 5 popular stations  
	・Found the popularity rank if ride types  
	・Found the variation in trip durations due to start time and day  
	→ Finished SQL. Moved on to Tableau for data viz  

■ Problems encountered and solutions  
	・The data set is too heavy (>1.1GB), so I couldn't open it. Thus I export the result of SQL query to csv files  

■ Reflections:   
	・I need to create an excel file to store new functions I learned while analyzing data  

※2024/12/29  
■ Tool used: Ppowerpoint, Tableau  

■ Steps taken:   
  〇 Visualize data  
	・Used Tableau to create data viz  
  ・Created powerpoint  

■ Problems encountered and solutions  
■ Reflections  
