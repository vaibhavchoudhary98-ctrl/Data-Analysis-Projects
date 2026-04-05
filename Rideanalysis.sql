
--Querying the first 5 rows
SELECT TOP 5 * FROM rides
SELECT TOP 5 * FROM stations
SELECT TOP 10 * FROM users

--Checking the data types for each table
EXEC sp_help users
EXEC sp_help rides
EXEC sp_help stations

--Chekcing for NUll values
SELECT *
FROM rides
WHERE ride_id IS NULL
	or user_id IS NULL
	or start_station_id is NULL
	or end_station_id IS NULL
	or start_time IS NULL
	or distance_km IS NULL

--There are no null values. 
--Count of rides based on rides classification on the time duration

WITH ride_class AS (
		SELECT *,
			CASE WHEN DATEDIFF(MINUTE, start_time, end_time) < 1 THEN 'cancel_ride' --Ride duration is too small
				WHEN DATEDIFF(MINUTE, start_time, end_time) BETWEEN 1 and 10 THEN 'short_ride'
				WHEN DATEDIFF(MINUTE, start_time, end_time) BETWEEN 10 AND 30 THEN 'medium_ride'
				WHEN DATEDIFF(MINUTE, start_time, end_time) >30 THEN 'long_ride' 
				END AS ride_type
		FROM rides
)
SELECT COUNT(CASE WHEN ride_type = 'cancel_ride' THEN 1 END) as total_cancel_rides,
		COUNT(CASE WHEN ride_type = 'short_ride' THEN 1 END) as total_short_rides,
		COUNT(CASE WHEN ride_type = 'medium_ride' THEN 1 END) as total_medium_rides,
		COUNT(CASE WHEN ride_type = 'long_ride' THEN 1 END) as total_long_ride
FROM ride_class




-- Ride Analysis

SELECT 
		COUNT(*) AS total_rides,
		MIN(distance_km) AS min_distance,
		MAX(distance_km) AS max_distance,
		CAST(ROUND(AVG(distance_km), 2) AS decimal(10,2)) AS avg_distance,
		AVG(DATEDIFF(MINUTE, start_time, end_time)) AS avg_ride_time,
		MAX(DATEDIFF(MINUTE, start_time, end_time)) AS max_ride_time,
		MIN(DATEDIFF(MINUTE, start_time, end_time)) AS min_ride_time
FROM rides 
WHERE DATEDIFF(MINUTE, start_time, end_time)>=1 --Only considering those rides whose time duration >= 1 min


--Peek hours

SELECT DATEPART(HOUR, start_time) as Hours,
		COUNT(*) AS hourly_rides
FROM rides
GROUP BY DATEPART(HOUR, start_time)
ORDER BY 1

--Popular stations 

WITH start_station AS (
SELECT s.station_name,
		COUNT(*) as start_rides
FROM rides r
JOIN stations s
	ON r.start_station_id = s.station_id
GROUP BY s.station_name
),

end_station AS (
SELECT s.station_name,
		COUNT(*) as end_rides
FROM rides r
JOIN stations s
	ON r.end_station_id = s.station_id
GROUP BY s.station_name
)

SELECT ss.station_name,
	start_rides,
	end_rides
FROM start_station ss
LEFT JOIN end_station es
	ON ss.station_name = es.station_name


--User membership ride analysis
SELECT u.membership_level, 
		COUNT(*) AS Total_rides,
		AVG(DATEDIFF(MINUTE, start_time, end_time)) as avg_ride_time,
		ROUND(AVG(distance_km), 1) as avg_distance
FROM rides r
LEFT Join users u
	ON r.user_id=u.user_id
GROUP BY u.membership_level



--Month wise total rides and avg ride duration for 2024

SELECT
	month, COUNT(ride_id) AS total_rides, COUNT(DISTINCT user_id) as no_of_distinct_users, AVG(DATEDIFF(MINUTE, start_time, end_time)) AS avg_ride_duration
FROM (
	SELECT
		ride_id, user_id, DATEPART(MONTH, start_time) AS month, start_time, end_time, distance_km
	FROM rides
	WHERE DATEPART(YEAR, start_time)=2024
	) AS ride_filter
GROUP BY month
ORDER BY 1



--Cohort analysis

WITH first_rides AS (
	SELECT user_id,
			MIN(DATEFROMPARTS(YEAR(start_time), MONTH(start_time), 1)) AS first_ride
	FROM rides
	GROUP BY user_id
),
monthly_users AS (
	SELECT DISTINCT user_id,
					DATEFROMPARTS(YEAR(start_time), MONTH(start_time),1) AS month
	FROM rides
),
user_status AS (
		SELECT mu.user_id,
				mu.month,
				CASE WHEN mu.month=fr.first_ride THEN 'New'
				WHEN EXISTS (
							SELECT 1
							FROM monthly_users prev
							WHERE prev.user_id = mu.user_id
							AND prev.month = DATEADD(MONTH, -1, mu.month)
							) THEN 'Existing'
				ELSE 'Returning'
				END AS status
		FROM monthly_users mu
		LEFT JOIN  first_rides fr
		ON mu.month = fr.first_ride
		AND mu.user_id = fr.user_id
),
drop_users AS (
		SELECT prev.month,
		COUNT(DISTINCT prev.user_id) as drop_user
 		FROM monthly_users prev
		LEFT JOIN monthly_users cur
			ON prev.user_id = cur.user_id
			AND cur.month = DATEADD(MONTH, 1, prev.month)
		WHERE cur.user_id IS NULL
		GROUP BY prev.month
)

SELECT
	us.month,
	COUNT(CASE WHEN status = 'New' THEN 1 END) as new_users,
	COUNT(CASE WHEN status = 'Existing' THEN 1 END) as exisitng_users,
	COUNT(CASE WHEN status = 'Returning' THEN 1 END) as returning_users,
	drop_user
FROM user_status us
LEFT JOIN drop_users du
ON us.month = du.month
GROUP BY us.month, drop_user
ORDER BY us.month
