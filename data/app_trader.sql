(SELECT 
FROM app_store_apps AS a)
INTERSECT 
(SELECT name 
 FROM play_store_apps AS p)

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

SELECT  name,price::money,content_rating,primary_genre,review_count::numeric
FROM app_store_apps
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
ORDER BY max_rating DESC NULLS LAST;




SELECT name,price::money,content_rating,rating,primary_genre,review_count::numeric
FROM app_store_apps
WHERE rating =5.0
ORDER BY review_count DESC





 (SELECT name,price::money,content_rating,rating,primary_genre,review_count::numeric
FROM app_store_apps
WHERE rating =5.0
ORDER BY review_count)
INTERSECT 
(SELECT name,price::money,content_rating,rating,genres,review_count::numeric
 FROM play_store_apps
WHERE rating =5.0
ORDER BY review_count)

--agv app price


--rev
SELECT AVG(review_count) / AVG(install_count::numeric) AS avg_ratio
FROM play_store_apps;
