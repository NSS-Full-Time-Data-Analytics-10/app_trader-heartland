(SELECT name
FROM app_store_apps AS a)
INTERSECT 
(SELECT name 
 FROM play_store_apps AS p)

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

--General recommendations
--Genre
--content rating
--price range
-------------------------------------APP STORY ONLY---------------
SELECT DISTINCT name,
  review_count,
  price,
  price::money * review_count::numeric AS money_users_purchasing_app
FROM
  app_store_apps
 ORDER BY money_users_purchasing_app DESC;



------------------------------------PLAY STORE ONLY-----------------------------------------------
SELECT DISTINCT name,
  review_count,
  price,
  price::money * review_count::numeric AS money_users_purchasing_app
FROM
  play_store_apps
 ORDER BY money_users_purchasing_app DESC;

------------------ COUNTING HOW MUCH THEY MADE OFF REVIEW COUNT BOTH TABLES------------
---REVEIW COUNT
SELECT DISTINCT a.name,
  CAST(a.review_count AS numeric),
  CAST(a.price AS money),
  CAST(a.price AS money) * CAST(a.review_count AS numeric) AS money_users_purchasing_app,
  'Present in Both' AS app_status
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p ON a.name = p.name
ORDER BY money_users_purchasing_app DESC, a.name;

----INSTALL COUNT
SELECT DISTINCT a.name,
  CAST(regexp_replace(p.install_count, '[^0-9]', '', 'g') AS numeric),
  CAST(a.price AS money),
  CAST(a.price AS money) * CAST(regexp_replace(p.install_count, '[^0-9]', '', 'g') AS numeric) AS money_users_purchasing_app,
  'Present in Both' AS app_status
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p ON a.name = p.name
ORDER BY money_users_purchasing_app DESC, a.name;


-----------------In-app PURCHASES----------------
--APP STORE
SELECT name, rating, ROUND((rating / .25) * 6 +12, 0) AS longevity_months
FROM app_store_apps;

SELECT
  name,
  rating,
  ROUND((rating / 0.25) * 6 + 12, 0) AS longevity_months,
  ROUND((rating / 0.25) * 6 + 12, 0) * 5000 AS monthly_profit
FROM
  app_store_apps;

--PLAY STORE
SELECT name, ROUND((ROUND(rating, 2) / 0.25) * 6 + 12, 0) AS longevity_months
FROM play_store_apps;

SELECT
  name,
  ROUND((ROUND(rating, 2) / 0.25) * 6 + 12, 0) AS longevity_months,
  ROUND((ROUND(rating, 2) / 0.25) * 6 + 12, 0) * 5000 AS monthly_profit
FROM
  play_store_apps;

--------- JOINING
SELECT DISTINCT
  a.name,
  CASE
    WHEN a.price::money BETWEEN '$0' AND '$2.50' THEN 25000
    ELSE a.price * 10000
  END AS rights_cost,
  CAST(regexp_replace(p.install_count, '[^0-9]', '', 'g') AS numeric),
  CAST(a.price AS money),
  CAST(a.price AS money) * CAST(regexp_replace(p.install_count, '[^0-9]', '', 'g') AS numeric) AS money_users_purchasing_app,
  ROUND((ROUND(a.rating, 2) / 0.25) * 6 + 12, 0) AS longevity_months,
  (ROUND((ROUND(a.rating, 2) / 0.25) * 6 + 12, 0) * 5000) - 100 AS monthly_profit,
  CASE
    WHEN a.price > 0 THEN a.price * 10000
    ELSE 25000
  END AS rights_cost
FROM
  app_store_apps AS a
  INNER JOIN play_store_apps AS p ON a.name = p.name
ORDER BY
  money_users_purchasing_app DESC,
  a.name;
  
  ---NAME,GENRE,RIGHTS_COST
SELECT DISTINCT
  a.name,
  CASE
    WHEN a.price::money BETWEEN '$0' AND '$2.50' THEN 25000
    ELSE a.price * 10000
  END AS rights_cost,
  a.primary_genre
FROM
  app_store_apps AS a
  INNER JOIN play_store_apps AS p ON a.name = p.name
ORDER BY
  rights_cost DESC,
  a.name;


SELECT DISTINCT
  a.name,
  CASE
    WHEN a.price::money BETWEEN '$0' AND '$2.50' THEN 25000
    ELSE a.price * 10000
  END AS rights_cost,
  a.primary_genre,
  (ROUND((ROUND(a.rating, 2) / 0.25) * 6 + 12, 0) * 5000) - 1000 AS monthly_profit,
  CASE
    WHEN a.price > 0 THEN a.price * 10000
    ELSE 25000
  END AS rights_cost
FROM
  app_store_apps AS a
  INNER JOIN play_store_apps AS p ON a.name = p.name
ORDER BY
  monthly_profit DESC,
  a.name;
  
--TOP 10  
WITH parts_of_profitability AS (
  SELECT DISTINCT 
    name,
    CASE WHEN price::money::numeric BETWEEN 0 AND 2.5 THEN 25008
         ELSE price::money::numeric * 10000
    END AS rights_cost,
    (rating / 0.25) * 6 + 12 * 1000 AS cost_of_lifespan,
    (rating / 0.25) * 6 + 12 * 5000 AS earnings_of_lifespan,
    install_count::money::numeric * price::money::numeric AS install_earnings
  FROM play_store_apps
)
SELECT 
  ((earnings_of_lifespan + install_earnings) - (rights_cost + cost_of_lifespan))::money AS profitability,
  name
FROM parts_of_profitability
ORDER BY profitability DESC NULLS LAST
LIMIT 10;


--- 4 apps for 4th of July

SELECT DISTINCT a.name, a.rating, p.rating, a.price, p.price,a.primary_genre
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name=p.name
WHERE a.rating >=4.5 AND a.primary_genre ILIKE '%%'
AND a.price BETWEEN 0.00 AND 2.50
ORDER BY a.rating DESC





--5.0 for apple store
SELECT  name,price::money,content_rating,primary_genre,review_count::numeric
FROM app_store_apps
WHERE rating =5.0
ORDER BY review_count DESC

--5.0 for playstore 
SELECT name,price::money,content_rating,rating,genres,review_count::numeric
FROM play_store_apps
WHERE rating =5.0
ORDER BY review_count DESC

--AVG rating
SELECT AVG(rating)
FROM app_store_apps

--MAX rating
SELECT name,MAX(rating) as max_rating
FROM app_store_apps
GROUP BY name, rating
ORDER BY max_rating DESC NULLS LAST;

--highest rated genre
SELECT primary_genre,MAX(rating) as max_rating
FROM app_store_apps
GROUP BY primary_genre
ORDER BY max_rating DESC NULLS LAST;

--Highest rated free apps
SELECT name, price::money, MAX(rating) AS max_rating
FROM app_store_apps
WHERE price = 0
GROUP BY name, price::money
ORDER BY max_rating DESC NULLS LAST;\

--Apps on both tables
(SELECT name
FROM app_store_apps AS a)
INTERSECT 
(SELECT name 
 FROM play_store_apps AS p)
 
 
 --Price for apps on APPLE store
SELECT
  name,price::money,
  CASE
    WHEN price::money = '$0' THEN '$25000'
    ELSE CAST(price::money * 10000 AS money)
  END AS price_for_app
FROM app_store_apps;


--Price for apps on PLAY store
SELECT
  name,price::money,
  CASE
    WHEN price::money = '$0' THEN '$25000'
    ELSE CAST(price::money * 10000 AS money)
  END AS price_for_app
FROM
  play_store_apps
  ORDER BY price DESC
  
  
  
--apps on both tables with rating
SELECT a.name, a.rating AS app_store_rating, p.rating AS play_store_rating,
       CASE WHEN a.rating = p.rating THEN 'Same' ELSE 'Different' END AS rating_comparison
FROM app_store_apps AS a
JOIN play_store_apps AS p ON a.name = p.name
INTERSECT
SELECT name, rating, rating, 'Same' AS rating_comparison
FROM app_store_apps
ORDER BY rating_comparison;

--lifespan on apple store
SELECT name, rating, ((rating / 0.25) * 6) / 12.0 AS projected_lifespan_in_years
FROM app_store_apps;

--lifespan on playstore
SELECT name, rating, ((rating / 0.25) * 6) / 12.0 AS projected_lifespan_in_years
FROM play_store_apps;

--finding return on investment
SELECT
  DISTINCT a.name,
  a.rating AS app_store_rating,
  p.rating AS play_store_rating,
  (a.rating / 0.25) * 6 AS projected_lifespan_years,  
  ((a.rating / 0.25) * 6) * 5000 - 1000 AS monthly_profit,
  ((a.rating / 0.25) * 6) * 5000 - 1000 - (a.price * 10000) AS total_profit,
  ((a.rating / 0.25) * 6) * 5000 - 1000 - (a.price * 10000) / (a.price * 10000) AS roi
FROM
  app_store_apps AS a
INNER JOIN
  play_store_apps AS p ON a.name = p.name
WHERE
  a.price * 10000 >= 25000
ORDER BY
  roi DESC
LIMIT 10;

--Profitabilty on playstore--
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


--TOP 10
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

---DISTINCT GENERES
--play sotre
SELECT DISTINCT genres
FROM play_store_apps

--app store
SELECT DISTINCT primary_genre
FROM play_store_apps



  












