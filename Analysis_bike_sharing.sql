-- Combine data from 12 tables
CREATE TABLE heroic-tide-442403-e9.Bike_Sharing.combined_data AS
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_01`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_02`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_03`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_04`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_05`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_06`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_07`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_08`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_09`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_10`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2024_11`
UNION ALL
SELECT * FROM `heroic-tide-442403-e9.Bike_Sharing.2023_12`


-- Clean data
-- remove duplicates, none found
SELECT DISTINCT *
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data

-- remove null data
DELETE FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
WHERE ride_id IS NULL OR
  rideable_type IS NULL OR
  started_at IS NULL OR
  ended_at IS NULL OR
  start_station_name IS NULL OR
  start_station_id IS NULL OR
  end_station_name IS NULL OR
  end_station_id IS NULL OR
  start_lat IS NULL OR
  start_lng IS NULL OR
  member_casual IS NULL

--Remove irrelevant data, none found

SELECT DISTINCT rideable_type
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data

SELECT DISTINCT member_casual
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data


--Calculate trip duration

SELECT 
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS duration_in_minutes
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
LIMIT 10

ALTER TABLE heroic-tide-442403-e9.Bike_Sharing.combined_data
ADD COLUMN duration_min INT64

UPDATE heroic-tide-442403-e9.Bike_Sharing.combined_data
SET
  duration_min = TIMESTAMP_DIFF(ended_at, started_at, MINUTE)
WHERE TRUE

--Split datetime to date and time

ALTER TABLE heroic-tide-442403-e9.Bike_Sharing.combined_data
ADD COLUMN  started_on DATE,
ADD COLUMN  started_at_time TIME,
ADD COLUMN  ended_on DATE,
ADD COLUMN  ended_at_time TIME


UPDATE heroic-tide-442403-e9.Bike_Sharing.combined_data
SET
  started_on = DATE(started_at),
  started_at_time = TIME(started_at),
  ended_on = DATE(ended_at),
  ended_at_time = TIME(ended_at)
WHERE TRUE

SELECT *
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
LIMIT 50

--Analysis
--1. What time of the day is the busiest?

SELECT member_casual,
  EXTRACT(HOUR FROM started_at_time) AS hour,
  COUNT(*) AS trip_total  
FROM `heroic-tide-442403-e9.Bike_Sharing.combined_data`
GROUP BY member_casual, hour
ORDER BY member_casual, trip_total desc

--2 What route is most taken by casuals?
SELECT CONCAT(start_station_name, " to ", end_station_name) AS route, COUNT(*) AS trip_total, AVG(duration_min) AS duration_avg
FROM `heroic-tide-442403-e9.Bike_Sharing.combined_data`
WHERE member_casual <> "casual"
GROUP BY route
ORDER BY trip_total desc
LIMIT 10

SELECT CONCAT(start_station_name, " to ", end_station_name) AS route, COUNT(*) AS trip_total, AVG(duration_min) AS duration_avg
FROM `heroic-tide-442403-e9.Bike_Sharing.combined_data`
WHERE member_casual = "casual"
GROUP BY route
ORDER BY trip_total desc
LIMIT 10

--3. Average duration

SELECT member_casual, COUNT(*) AS trip_total, AVG(duration_min) AS avg_duration, SUM(duration_min) AS duration_total
FROM `heroic-tide-442403-e9.Bike_Sharing.combined_data`
GROUP BY member_casual


--3 What month is the busiest?

SELECT 
  member_casual,
  EXTRACT(MONTH FROM started_on) AS month,
  COUNT(*) AS trip_total
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
GROUP BY member_casual, month
ORDER BY member_casual, trip_total desc

-- 4 What day of the week is the busiest?

SELECT
  member_casual,
  FORMAT_DATE('%A',started_on) AS day_of_week,
  COUNT(*) AS trip_total, 
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
GROUP BY member_casual, day_of_week
ORDER BY member_casual, trip_total desc


-- 5 Station popularities
SELECT
  member_casual, start_station_name,start_lat, start_lng,
  COUNT(*) AS trip_counts
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
WHERE member_casual = "casual"
GROUP BY member_casual, start_station_name,start_lat, start_lng
ORDER BY trip_counts desc
LIMIT 10


  member_casual, start_station_name, start_lat, start_lng,
  COUNT(*) AS trip_counts
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
WHERE member_casual <> "casual"
GROUP BY member_casual, start_station_name,start_lat, start_lng
ORDER BY trip_counts desc
LIMIT 10


--6  Popular type of ride
SELECT 
  member_casual,
  rideable_type,
  COUNT(*) AS trip_counts
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
GROUP BY member_casual, rideable_type
ORDER BY member_casual, trip_counts desc


--7 Do trip durations vary significantly by start time or day for each group?
--7a. by start time
SELECT member_casual,
  EXTRACT(HOUR FROM started_at_time) AS hour,
  SUM(duration_min) AS duration_total,
  AVG(duration_min) AS duration_avg 
FROM `heroic-tide-442403-e9.Bike_Sharing.combined_data`
GROUP BY member_casual, hour
ORDER BY member_casual, duration_total desc
--7 Do trip durations vary significantly by start time or day for each group?
--7b. By start day

SELECT
  member_casual,
  FORMAT_DATE('%A',started_on) AS day_of_week,
  SUM(duration_min) AS duration_total,
  AVG(duration_min) AS duration_avg
FROM heroic-tide-442403-e9.Bike_Sharing.combined_data
GROUP BY member_casual, day_of_week
ORDER BY member_casual desc
