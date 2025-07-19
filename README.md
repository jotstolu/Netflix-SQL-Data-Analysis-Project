# 🎬 Netflix SQL Data Analysis Project

This project explores the **Netflix dataset** using **SQL queries** to uncover trends, patterns, and business insights that could help stakeholders understand content distribution, viewer preferences, and platform optimization.

## 📊 Project Objective

The goal is to answer key business questions such as:
- What is the ratio of movies to TV shows?
- Which countries and genres dominate Netflix's catalog?
- Who are the most featured actors or directors?
- How has Netflix’s content evolved in recent years?

## 🧰 Tools & Technologies

- **SQL Server / T-SQL**
- **Netflix dataset** (in `.csv` format)

## 🔍 Business Questions Answered

1. **Count the Number of Movies vs TV Shows**
2. **Find the Most Common Rating for Movies and TV Shows**
3. **List All Movies Released in the Year 2021**
4. **Top 5 Countries with the Most Content on Netflix**
5. **Identify the Longest Movie**
6. **Find Content Added in the Last 5 Years**
7. **Find All Movies/TV Shows by Director 'Rajiv Chilaka'**
8. **List All TV Shows with More Than 5 Seasons**
9. **Count the Number of Content Items in Each Genre**
10. **Average Yearly Content Released in India**
11. **List All Movies that are Documentaries**
12. **Find All Content Without a Director**
13. **Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years**
14. **Top 10 Actors with Most Movies Produced in India**
15. **Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords**

## SQL Queries

**1. Count the Number of Movies vs TV Shows**
```sql
SELECT type, COUNT(type) AS total_count
FROM netflix_tb
GROUP BY type;
```
![number_of_movies](https://github.com/jotstolu/Netflix-SQL-Data-Analysis-Project/blob/main/assets/img/1.%20Count%20the%20Number%20of%20Movies%20vs%20TV%20Shows.png?raw=true)

**2. Most Common Rating for Movies and TV Shows**
```sql
WITH common_rating AS (
    SELECT type, rating, COUNT(*) AS total_count,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank
    FROM netflix_tb
    GROUP BY type, rating
)
SELECT type, rating, total_count FROM common_rating WHERE rank = 1;
```
![most_common_rating](https://github.com/jotstolu/Netflix-SQL-Data-Analysis-Project/blob/main/assets/img/2.%20Find%20the%20Most%20Common%20Rating%20for%20Movies%20and%20TV%20Shows.png?raw=true)


**3. All Movies Released in 2021**
```sql
SELECT title, type, release_year
FROM netflix_tb
WHERE type = 'Movie' AND release_year = 2021;
```
![movies_released](https://github.com/jotstolu/Netflix-SQL-Data-Analysis-Project/blob/main/assets/img/3.%20List%20All%20Movies%20released%20in%20year%202021.png?raw=true)

 
**4. Top 5 Countries with the Most Content**
```sql
SELECT TOP (5) TRIM(value) AS country, COUNT(*) AS count
FROM netflix_tb
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY count DESC;
```
![Top_5_countries](https://github.com/jotstolu/Netflix-SQL-Data-Analysis-Project/blob/main/assets/img/4.%20Find%20the%20Top%205%20Countries%20with%20the%20Most%20Content%20on%20Netflix.png?raw=true)

-- 5. Identify the Longest Movie
SELECT title, duration
FROM netflix_tb
WHERE type = 'Movie'
  AND duration = (SELECT MAX(duration) FROM netflix_tb);

-- 6. Content Added in the Last 5 Years
SELECT title, date_added
FROM netflix_tb
WHERE date_added >= DATEADD(YEAR, -5, GETDATE());

-- 7. Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT type, title, director
FROM netflix_tb
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. TV Shows with More Than 5 Seasons
SELECT title, type, duration
FROM netflix_tb
WHERE type = 'TV Show' AND duration > '5 Seasons';

-- 9. Number of Content Items per Genre
SELECT TRIM(value) AS genre, COUNT(*) AS total_content
FROM netflix_tb
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value)
ORDER BY COUNT(*) DESC;

-- 10. Average Yearly Content Released in India
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

-- 11. All Movies that are Documentaries
SELECT title, type, listed_in
FROM netflix_tb
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

-- 12. All Content Without a Director
SELECT type, director
FROM netflix_tb
WHERE director IS NULL;

-- 13. Movies Featuring 'Salman Khan' in Last 10 Years
SELECT cast, title, release_year
FROM netflix_tb
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;

-- 14. Top 10 Actors in Indian Movies
SELECT TOP 10 
    TRIM(value) AS actor,
    COUNT(*) AS appearances
FROM netflix_tb
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India' AND cast IS NOT NULL
GROUP BY TRIM(value)
ORDER BY COUNT(*) DESC;

-- 15. Content Categorized by 'Kill' or 'Violence' Keywords
SELECT category, COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_tb
) AS categorized_content
GROUP BY category;

---

