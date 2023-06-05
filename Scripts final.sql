--Profitability is assumed earnings/2 + downloads cost - marketing/month ($12,000)*lifespan - rights cost
SELECT 
FROM play_store_apps

--Rights cost--
SELECT DISTINCT (name),
	CASE WHEN price = '0' THEN '$25,000' 
	ELSE price::MONEY *10000 END AS rights_cost
FROM play_store_apps
ORDER BY rights_cost DESC;

--Cost over lifetime)
WITH lifespan_cost AS (SELECT (rating / 0.25)/2*12 AS lifespan_in_months, name
						FROM play_store_apps
						ORDER BY rating DESC NULLS LAST)
SELECT lifespan_in_months*1000 AS cost_over_lifetime, name
FROM lifespan_cost;

--Earnings for in app purchases over life of app--
WITH lifespan_cost AS (SELECT (rating / 0.25)/2*12 AS lifespan_in_months, name
						FROM play_store_apps
						ORDER BY rating DESC NULLS LAST)
SELECT lifespan_in_months*5000 AS earnings_over_lifetime, name
FROM lifespan_cost;

--PRICE RANGE--
SELECT name, a.content_rating, a.rating, a.primary_genre,
CASE WHEN a.price BETWEEN 0.00 AND 1.99 THEN 'cheap'
	 WHEN a.price BETWEEN 2.00 and 3.99 THEN 'affordable'
	 WHEN a.price > 4.00 THEN 'costly' END AS price_range
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
WHERE a.rating > 4.5
ORDER BY a.rating DESC


SELECT name, rating, category
FROM play_store_apps
WHERE rating =5.0
GROUP BY name, rating, category
ORDER BY category DESC;
-- 274 rows--

--1 AVG price for app


--2 avg app rating, highest rated app
SELECT AVG(rating)
FROM play_store_apps
--ANSWER is 4.19--

--3 highest rated genre--
SELECT AVG(rating), genres, content_rating 
FROM play_store_apps
GROUP BY genres, content_rating
ORDER BY AVG(rating) DESC NULLS LAST
LIMIT 5;
--4 highest rated free app--
--5 age of user (content rating)
--review or install count--
SELECT name, SUM(review_count)AS review_counts, content_rating
FROM play_store_apps
GROUP BY name, content_rating
ORDER BY review_counts DESC NULLS LAST
--cost of rights--
SELECT name,
	CASE WHEN price = '0' THEN '$25,000' 
	ELSE price::MONEY *10000 END AS rights_cost
FROM play_store_apps
ORDER BY rights_cost DESC 
--lifespan of app--
SELECT (rating / 0.25)/2*12 AS lifespan_in_months, name
FROM play_store_apps
ORDER BY rating DESC NULLS LAST
--potential gross revenue =  lifespan in months * 5000 per month + price of app*downloads but I don't know how to project potential downloads/month

 

SELECT name, review_count
FROM play_store_apps
ORDER BY review_count DESC

--TOTAL POTENTIAL EARNINGS OVER LIFE OF APP--
SELECT install_count::MONEY::NUMERIC*price::MONEY::NUMERIC AS install_earnings, name
FROM play_store_apps
ORDER BY install_earnings DESC


--POTENTIAL APPS ON BOTH PLATFORMS
SELECT name, rating, price, review_count::integer
FROM app_store_apps AS a
WHERE a.rating > 4.5
	AND a. price >= 0.99
	AND a.review_count::integer > 100000
ORDER BY price DESC NULLS LAST;

SELECT name, rating, price::money::numeric, install_count::money::numeric
FROM play_store_apps AS p
WHERE p.rating > 4.5
	AND p. price::money::numeric >= 0.99
	AND p.install_count::money::numeric > 500000
ORDER BY price DESC NULLS LAST



--TOTAL POTENTIAL EARNINGS OVER LIFE OF APP--
SELECT install_count::MONEY::NUMERIC*price::MONEY::NUMERIC AS install_earnings, name
FROM play_store_apps
ORDER BY install_earnings DESC

WITH parts_of_profitability AS (SELECT DISTINCT (name),
								CASE WHEN price::money::numeric BETWEEN 0 AND 2.5 THEN 25000
									 ELSE price::MONEY::numeric *10000 END AS rights_cost,
									(rating / 0.25)*6+12*1000 AS cost_of_lifespan,
									(rating / 0.25)*6+12*5000 AS earnings_of_lifespan,
									 review_count::MONEY::NUMERIC*price::MONEY::NUMERIC AS install_earnings
								FROM app_store_apps)
SELECT((earnings_of_lifespan+install_earnings)-(rights_cost+cost_of_lifespan))::money AS profitability, name, rights_cost,  cost_of_lifespan, earnings_of_lifespan, install_earnings
FROM parts_of_profitability
ORDER BY profitability DESC NULLS LAST	
LIMIT 11;