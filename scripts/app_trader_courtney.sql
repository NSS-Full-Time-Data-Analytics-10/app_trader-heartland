SELECT DISTINCT name
FROM app_store_apps;
--7197 apps

SELECT DISTINCT name
FROM play_store_apps;
--10840 apps

(SELECT name
FROM app_store_apps)
INTERSECT
(SELECT name
FROM play_store_apps);
--328 same name apps on both platforms

SELECT DISTINCT price
FROM app_store_apps
ORDER BY price;
--36 distinct prices

SELECT DISTINCT price
FROM play_store_apps
ORDER BY price;

SELECT COUNT(name), price
FROM app_store_apps
GROUP BY price
ORDER BY price;
--most apps are free or under $5
--could create tiers

SELECT COUNT(name), price::money
FROM play_store_apps
GROUP BY price
ORDER BY price;




SELECT COUNT(name), price, ROUND(AVG(rating),2) AS avg_rating_price
FROM app_store_apps
GROUP BY price
ORDER BY avg_rating_price DESC;

SELECT COUNT(name), price, ROUND(AVG(rating),2) AS avg_rating_price
FROM app_store_apps
GROUP BY price
ORDER BY price;

SELECT review_count

SELECT primary_genre, COUNT(primary_genre) AS genre_count, ROUND(AVG(price),2) AS 					avg_genre_price,
				ROUND(AVG(rating),2) AS avg_genre_rating
FROM app_store_apps
GROUP BY primary_genre
ORDER BY genre_count DESC;
--games are majority of apps

SELECT genres, COUNT(genres) AS genre_count, ROUND(AVG(price::money::numeric),2) AS 					avg_genre_price,
				ROUND(AVG(rating),2) AS avg_genre_rating
FROM play_store_apps
GROUP BY genres
ORDER BY genre_count DESC;

SELECT *
FROM play_store_apps
--games are majority of apps

SELECT primary_genre, COUNT(primary_genre) AS genre_count, ROUND(AVG(price),2) AS 					avg_genre_price,
				ROUND(AVG(rating),2) AS avg_genre_rating
FROM app_store_apps
GROUP BY primary_genre
ORDER BY avg_genre_rating DESC;
--highest rated genres -- 
--"Productivity"
--"Music"
--"Photo & Video"
--"Business"
--"Health & Fitness"

SELECT primary_genre, COUNT(primary_genre) AS genre_count, ROUND(AVG(price),2) AS 					avg_genre_price,
				ROUND(AVG(rating),2) AS avg_genre_rating
FROM app_store_apps
GROUP BY primary_genre
ORDER BY avg_genre_price DESC;

SELECT name, price, rating, review_count
FROM app_store_apps
WHERE primary_genre ILIKE 'GAMES'
AND price = 0.0
AND rating = 5.0
AND review_count::numeric > 50000
ORDER BY review_count::numeric DESC;
--12 free games with 5.0 rating and at least 50k reviews


SELECT *
FROM app_store_apps
WHERE price = 0.0
AND rating = 5.0
AND review_count::numeric > 50000
ORDER BY review_count::numeric DESC;
--21 free apps with 5.0 rating and at least 50k reviews

(SELECT name
FROM app_store_apps
WHERE price = 0.0
AND rating = 5.0
AND review_count::numeric > 50000
ORDER BY review_count::numeric DESC)
INTERSECT
((SELECT name
FROM app_store_apps)
INTERSECT
(SELECT name
FROM play_store_apps))
---Highly rated free apple apps that appear on both apps

SELECT name, size_bytes::numeric
FROM app_store_apps
ORDER BY size_bytes::numeric DESC;

SELECT name, size::numeric
FROM play_store_apps
ORDER BY size::numeric DESC;

SELECT COUNT(name), content_rating
FROM app_store_apps
GROUP BY content_rating;

SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;


--in app purchases revenue-- 5000*lifespan(how many months(rating))
SELECT *
FROM play_store_apps

SELECT CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating
FROM play_store_apps;

SELECT CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating
FROM play_store_apps;

SELECT DISTINCT rating
FROM app_store_apps;

SELECT DISTINCT rating
FROM play_store_apps;

SELECT *
FROM app_store_apps;

SELECT ROUND(rating/25, 2) * 25 AS rounded_rating
FROM app_store_apps;

SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
		CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
		(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 5000 AS inapp_revenue 
FROM app_store_apps
ORDER BY inapp_revenue DESC;

SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
		CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
		(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 5000 AS inapp_revenue 
FROM play_store_apps
ORDER BY inapp_revenue DESC NULLS LAST;

--installs revenue (app price * installs)

SELECT name, price * (review_count::money::numeric/.028) AS install_revenue
FROM app_store_apps
ORDER BY install_revenue DESC;


SELECT name, price::money::numeric * install_count::money::numeric AS install_revenue
FROM play_store_apps
ORDER BY install_revenue DESC;

--rights costs--

SELECT CASE WHEN price::money::numeric < 2.50 THEN 25000
		ELSE price::money::numeric * 10000 END AS rights_costs
FROM play_store_apps

SELECT CASE WHEN price::money::numeric < 2.50 THEN 25000
		ELSE price::money::numeric * 10000 END AS rights_costs
FROM app_store_apps

--marketing costs--

SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
		CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
		(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 1000 AS marketing_costs 
FROM play_store_apps
ORDER BY marketing_costs DESC NULLS LAST;

SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
		CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
		(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 1000 AS marketing_costs 
FROM app_store_apps
ORDER BY marketing_costs DESC NULLS LAST;

putting it all together


SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
		CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
		(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 5000 AS inapp_revenue,
		price * (review_count::money::numeric/.028) AS install_revenue,
		CASE WHEN price::money::numeric < 2.50 THEN 25000
		ELSE price::money::numeric * 10000 END AS rights_costs,
		 (CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 1000 AS marketing_costs
FROM app_store_apps;


SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
		CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
		(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 5000 AS inapp_revenue,
		price::money::numeric * (review_count::money::numeric/.028) AS install_revenue,
		CASE WHEN price::money::numeric < 2.50 THEN 25000
		ELSE price::money::numeric * 10000 END AS rights_costs,
		 (CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 1000 AS marketing_costs
FROM play_store_apps;




WITH profit_math AS (SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
						CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
						(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 5000 AS inapp_revenue,
						price::money::numeric * (review_count::money::numeric/.028) AS install_revenue,
						CASE WHEN price::money::numeric < 2.50 THEN 25000
						ELSE price::money::numeric * 10000 END AS rights_costs,
		 				(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 1000 AS marketing_costs
						FROM app_store_apps)
SELECT name, rating, primary_genre, content_rating, price::money::numeric, (inapp_revenue + install_revenue)-(rights_costs + marketing_costs) AS profitability
FROM profit_math
JOIN app_store_apps USING (name)
ORDER BY profitability DESC
LIMIT 10;


WITH profit_math_p AS		(SELECT name, CAST(ROUND(rating/25, 2) * 25 as numeric) AS rounded_rating,
						CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12 AS lifespan_months,
						(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 5000 AS inapp_revenue,
						price::money::numeric * (review_count::money::numeric) AS install_revenue,
						CASE WHEN price::money::numeric < 2.50 THEN 25000
						ELSE price::money::numeric * 10000 END AS rights_costs,
		 				(CAST(ROUND(rating/25, 2) * 25 as numeric) * 24 + 12) * 1000 AS marketing_costs
						FROM play_store_apps) 
SELECT name, genres, content_rating, price::money::numeric, (inapp_revenue + install_revenue)-(rights_costs + marketing_costs) AS profitability
FROM profit_math_p
JOIN play_store_apps USING (name)
ORDER BY profitability DESC NULLS LAST;














