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

SELECT COUNT(name), price
FROM app_store_apps
GROUP BY price
ORDER BY price;
--most apps are free or under $5
--could create tiers


SELECT COUNT(name), price, ROUND(AVG(rating),2) AS avg_rating_price
FROM app_store_apps
GROUP BY price
ORDER BY avg_rating_price DESC;

SELECT COUNT(name), price, ROUND(AVG(rating),2) AS avg_rating_price
FROM app_store_apps
GROUP BY price
ORDER BY price;



SELECT primary_genre, COUNT(primary_genre) AS genre_count, ROUND(AVG(price),2) AS 					avg_genre_price,
				ROUND(AVG(rating),2) AS avg_genre_rating
FROM app_store_apps
GROUP BY primary_genre
ORDER BY genre_count DESC;
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