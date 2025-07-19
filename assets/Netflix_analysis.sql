--- 1. Count the Number of Movies vs TV Shows
select type, 
count(type) as total_count
from netflix_tb
group by type

-- 2. Find the Most Common Rating for Movies and TV Shows
with common_rating as 
(select type,rating,
count(*)as total_count,
rank() over (partition by type order by count(*) desc) as rank
from netflix_tb
group by type, rating)
select type, rating, total_count from common_rating
where rank = 1

-- 3. List All Movies released in year 2021
select title, type, release_year 
from netflix_tb
where type = 'Movie' and release_year = 2021

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT TOP (5) TRIM(value) AS country, COUNT(*) AS count
FROM netflix_tb
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY count DESC;

-- 5. Identify the Longest Movie
select title, duration
from netflix_tb
where type = 'Movie'
and duration = (select max(duration) from netflix_tb)

-- 6.Find Content Added in the Last 5 Years
SELECT title, date_added 
from netflix_tb
where date_added >= DATEADD(YEAR, -5, GETDATE())

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select type,title,director 
from netflix_tb
where director LIKE '%Rajiv Chilaka%'

-- 8. List All TV Shows with More Than 5 Seasons
select title, type, duration
from netflix_tb
where type = 'TV Show' and duration > '5 Seasons'

-- 9. Count the Number of Content Items in Each Genre
select trim(value) as genre, count(*) as total_content
FROM netflix_tb
CROSS APPLY STRING_SPLIT(listed_in, ',')
group by trim(value)
order by count(*) desc


-- 10.Find each year and the average numbers of content release in India on netflix.
SELECT 
    YEAR(date_added) AS year,
	COUNT(*) AS total_content,
    ROUND(
        CAST(COUNT(*) AS NUMERIC) * 100.0 / 
        CAST((SELECT COUNT(*) FROM netflix_tb WHERE country = 'India') AS NUMERIC),
        2
    ) AS avg_content_year
FROM netflix_tb
WHERE country = 'India'
GROUP BY YEAR(date_added)
ORDER BY COUNT(*) DESC;

-- 11. List All Movies that are Documentaries
SELECT title, type, listed_in
FROM netflix_tb
WHERE type = 'Movie' and listed_in LIKE '%Documentaries';


--  12 Find All Content Without a Director
select type, director
from netflix_tb
where director is null

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT cast, title, release_year
FROM netflix_tb
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT TOP 10 
    TRIM(value) AS actor,
    COUNT(*) AS appearances
FROM netflix_tb
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India' AND cast IS NOT NULL
GROUP BY TRIM(value)
ORDER BY COUNT(*) DESC;

--- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_tb
) AS categorized_content
GROUP BY category;



