SELECT name, price, rating, 
CASE WHEN price > 2.50 THEN (CAST(price AS int)) * 10000
	 WHEN price < 2.50 THEN 25000
	 END AS purchase_price
from app_store_apps;

SELECT name, rating, ROUND((rating / .25) * 6 +12, 0) AS longevity_months
FROM app_store_apps;

SELECT name, rating, ROUND((ROUND(rating, 2) / 0.25) * 6 + 12, 0) AS longevity_months
FROM play_store_apps;

SELECT name, rating, ROUND((rating / 0.25) * 6 + 12, 0) AS longevity_months
FROM play_store_apps;

SELECT name, ROUND(rating, 2)
FROM play_store_apps;

SELECT CAST(ROUND(rating/25, 2) * 25 as numeric(4,2)) AS rounded_rating
FROM play_store_apps;

SELECT AVG(review_count)/AVG(install_count::money::numeric)
FROM play_store_apps;

SELECT install_count::money::numeric, name
FROM play_store_apps
ORDER BY install_count::money::numeric DESC;

SELECT ROUND(review_count::money::numeric/0.028, 0) AS installs, name
FROM app_store_apps
ORDER BY installs DESC NULLS LAST;

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

SELECT name, genres
FROM play_store_apps
WHERE install_count::money::numeric >= 1000000000;

SELECT *
FROM play_store_apps;

WITH parts_of_profitability AS (SELECT DISTINCT (name),
								CASE WHEN price::money::numeric BETWEEN 0 AND 2.5 THEN 25000
									 ELSE price::MONEY::numeric *10000 END AS rights_cost,
									(rating / 0.25)*6+12*1000 AS cost_of_lifespan,
									(rating / 0.25)*6+12*5000 AS earnings_of_lifespan,
									 review_count::MONEY::NUMERIC*price::MONEY::NUMERIC AS install_earnings
								FROM play_store_apps)
SELECT((earnings_of_lifespan+install_earnings)-(rights_cost+cost_of_lifespan))::money AS profitability, name, rights_cost,  cost_of_lifespan, earnings_of_lifespan, install_earnings
FROM parts_of_profitability
ORDER BY profitability DESC NULLS LAST	
LIMIT 11;

--Profitability of App store apps--
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

WITH parts_of_profitability AS (SELECT DISTINCT (name),
								CASE WHEN price::money::numeric BETWEEN 0 AND 2.5 THEN 25000
									 ELSE price::MONEY::numeric *10000 END AS rights_cost,
									(rating / 0.25)*6+12*1000 AS cost_of_lifespan,
									(rating / 0.25)*6+12*5000 AS earnings_of_lifespan,
									 review_count::MONEY::NUMERIC*price::MONEY::NUMERIC AS install_earnings
								FROM play_store_apps)
SELECT((earnings_of_lifespan+install_earnings)-(rights_cost+cost_of_lifespan))::money AS profitability, name, rights_cost,  cost_of_lifespan, earnings_of_lifespan, install_earnings
FROM parts_of_profitability
ORDER BY profitability DESC NULLS LAST	
LIMIT 11;