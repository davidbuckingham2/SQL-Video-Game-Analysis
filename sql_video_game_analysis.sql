 -- Select all information for the top ten best-selling games
 -- Order the results from best-selling game down to tenth best-selling
SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10

--------------------------------------------------------------------------------------

-- Join games_sales and reviews
-- Select a count of the number of games where both critic_score and user_score are null

SELECT COUNT(g.game)
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
WHERE critic_score IS NULL and user_score IS NULL

--------------------------------------------------------------------------------------

-- Select release year and average critic score for each year, rounded and aliased
-- Join the game_sales and reviews tables
-- Group by release year
-- Order the data from highest to lowest avg_critic_score and limit to 10 results

SELECT g.year, ROUND(AVG(r.critic_score), 2) as avg_critic_score
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
ORDER BY avg_critic_score DESC
LIMIT 10

--------------------------------------------------------------------------------------

-- Update the query so that it only returns years that have more than four reviewed games

SELECT g.year, COUNT(g.game) as num_games, ROUND(AVG(r.critic_score), 2) as avg_critic_score
FROM game_sales as g
JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_critic_score DESC
LIMIT 10

------------------------------------------------------------------------------------------

-- Use tables containing top critic years and top critic years containing > 4 games
-- Select the year and avg_critic_score for those years that dropped off the list of critic favorites
-- Order the results from highest to lowest avg_critic_score

SELECT year, avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_years_more_than_four_games
ORDER BY avg_critic_score DESC

------------------------------------------------------------------------------------------

-- Looking at games loved by players
-- Include only years with more than four reviewed games; group data by year
-- Order data by avg_user_score, and limit to ten results

SELECT g.year, ROUND(AVG(user_score),2) as avg_user_score, Count(g.game) as num_games
FROM game_sales as g
INNER JOIN reviews as r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10

-------------------------------------------------------------------------------------------

-- Looking at years loved by both players and critics
-- Using pre-made top_critic_years_more_than_four_games and top_user_years_more_than_four_games tables
-- Select the year results that appear on both tables

SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games

-----------------------------------------------------------------------------------------------

-- Analyzing sales for the best reviewed years
-- Select year and sum of games_sold, aliased as total_games_sold; order results by total_games_sold descending
-- Filter game_sales based on whether each year is in the list returned in the previous task

SELECT g.year, SUM(g.games_sold) as total_games_sold
FROM game_sales as g
WHERE g.year IN
(SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games)

GROUP BY g.year
ORDER BY total_games_sold DESC