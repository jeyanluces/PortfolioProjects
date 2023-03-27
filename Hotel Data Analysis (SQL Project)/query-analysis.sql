--importing all necessary tables
--SELECT *
--	FROM dbo.['2018$']
--UNION
--SELECT *
--	FROM dbo.['2019$']
--UNION
--SELECT *
--	FROM dbo.['2020$'];

-- temporary table
-- created so can refer back to this tables as one table
--with hotels as (
--SELECT *
--	FROM dbo.['2018$']
--UNION
--SELECT *
--	FROM dbo.['2019$']
--UNION
--SELECT *
--	FROM dbo.['2020$'])

--	--SELECT * from hotels


	-- DATA EXLORATORY -- 
	-- Is the hotel revenue growing by year? 
	-- there's no revenue column but there is 'adr' (dairy rate), 'stays_in_weekend_nights', 'stays_in_week_nights'

	-- POA: Create a new column. Add stays in the weekend nights and stay in week nights, then multiply it by adr.

--with hotels as (
--SELECT *
--	FROM dbo.['2018$']
--UNION
--SELECT *
--	FROM dbo.['2019$']
--UNION
--SELECT *
--	FROM dbo.['2020$']
--)
	
--	SELECT arrival_date_year
--		, hotel
--		, round(sum(adr*(stays_in_week_nights+stays_in_weekend_nights)), 2) AS revenue 
--	FROM hotels
--	GROUP BY arrival_date_year 
--					 , hotel
--	ORDER BY revenue DESC

	-- there's revenue growth between 2018-2019, and a significant loss in 2020

	-------------------------------------------------------------------------------------------

	--SELECT @@SERVERNAME

	-- Joining the remaning tables with 'hotels' dataset
with hotels as (
	SELECT *
		FROM dbo.['2018$']
	UNION
	SELECT *
		FROM dbo.['2019$']
	UNION
	SELECT *
		FROM dbo.['2020$']
)

SELECT * FROM hotels
LEFT JOIN dbo.market_segment$
	ON hotels.market_segment = market_segment$.market_segment
LEFT JOIN dbo.meal_cost$
	ON meal_cost$.meal = hotels.meal


	-- contains the discount to each market segment type
	--SELECT * FROM dbo.market_segment$
	-- contains the price of meal type
	--SELECT * FROM dbo.meal_cost$