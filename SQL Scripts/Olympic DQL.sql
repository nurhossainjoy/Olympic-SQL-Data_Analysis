/* ============================================================
   OLYMPIC DATASET - SQL PRACTICE & ANALYSIS PROJECT
   Author: MD Nur Hossain Joy
   Education: IBA, University of Rajshahi (MBA)
   Professional Background:
	• Former Finance Executive, MetLife Bangladesh
	• Former Accounts & Finance Executive, IFAD Motors
  
   Project: Olympic SQL Analysis
   Database: PostgreSQL
   Table: public.olympic

   Description:
   This project contains 20 SQL practice and analysis questions
   based on an Olympic athletes dataset

   SQL Concepts Used:
   - SELECT
   - WHERE
   - DISTINCT
   - ORDER BY
   - LIMIT
   - GROUP BY
   - HAVING
   - Aggregate Functions
   - Conditional Aggregation
   - FILTER
   - Common Table Expressions (CTEs)
   - Window Functions
   - DENSE_RANK()

   Dataset Columns:
   ID, Name, Sex, Age, Height, Weight, Team, NOC,
   Games, Year, Season, City, Sport, Event, Medal

============================================================ */


/*============================================================
   🟢 EASY LEVEL
============================================================*/

/*============================================================
   QUESTION 1
   Display all columns and the first 10 records from the
   olympic table.
============================================================*/
SELECT *
FROM public.olympic
LIMIT 10;
/*============================================================
   QUESTION 2
   Find all athletes who are from Bangladesh.
============================================================*/
SELECT *
FROM public.olympic
WHERE team = 'Bangladesh';
/*============================================================
   QUESTION 3
   Show all distinct sports available in the Olympics dataset.
============================================================*/
SELECT DISTINCT sport
FROM public.olympic
ORDER BY sport;
/*============================================================
   QUESTION 4
   Find all athletes who participated in the 2012 Olympics.
   Display:
   - Name
   - Team
   - Sport
   - Event
============================================================*/
SELECT 
year, 
name, 
team, 
sport, 
event 
FROM olympic 
WHERE year = 2012;
/*============================================================
   QUESTION 5
   Find all athletes who won a Gold medal.

   Display:
   - Name
   - Team
   - Sport
   - Event
   - Year
============================================================*/
SELECT
name,
team,
sport,
event,
year
FROM public.olympic
WHERE medal = 'Gold';


/*============================================================
   QUESTION 6
   Find all female athletes who are older than 30 years.
   Sort the result by age in descending order.
============================================================*/

SELECT *
FROM public.olympic
WHERE sex = 'F'
AND age > 30
ORDER BY age DESC;


/*============================================================
   🟡 INTERMEDIATE LEVEL
 ============================================================*/


/*============================================================
   QUESTION 7
   Find the total number of unique athletes representing
   each country/team.

   Display:
   - Team
   - Number of Athletes

   Sort from highest to lowest.
============================================================*/

SELECT
team,
COUNT(DISTINCT id) AS number_of_athletes
FROM public.olympic
GROUP BY team
ORDER BY number_of_athletes DESC;


/*============================================================
   QUESTION 8
   Find the number of unique athletes in each sport.

   Display:
   - Sport
   - Number of Unique Athletes
============================================================*/

SELECT
sport,
COUNT(DISTINCT id) AS number_of_unique_athletes
FROM public.olympic
GROUP BY sport
ORDER BY number_of_unique_athletes DESC;


/*============================================================
   QUESTION 9
   Calculate the average age of athletes for each gender.

   Display:
   - Sex
   - Average Age
============================================================*/

SELECT
sex,
ROUND(AVG(age::NUMERIC), 2) AS average_age
FROM public.olympic
GROUP BY sex;


/*============================================================
   QUESTION 10
   Find the total number of medals won by each team.

   Display:
   - Team
   - Total Medals

   Only include teams that won at least one medal.
   Sort from highest to lowest.
============================================================*/

SELECT
team,
COUNT(medal) AS total_medals
FROM public.olympic
WHERE medal IS NOT NULL
GROUP BY team
ORDER BY total_medals DESC;


/*============================================================
   QUESTION 11
   Find the number of Gold, Silver, and Bronze medals won
   by each team.

   Display:
   - Team
   - Gold Medals
   - Silver Medals
   - Bronze Medals

   Sort by total medals in descending order.
============================================================*/

SELECT
team,
COUNT(*) FILTER (WHERE medal = 'Gold') AS gold_medals,
COUNT(*) FILTER (WHERE medal = 'Silver') AS silver_medals,
COUNT(*) FILTER (WHERE medal = 'Bronze') AS bronze_medals,
COUNT(medal) AS total_medals
FROM public.olympic
GROUP BY team
ORDER BY total_medals DESC;


/*============================================================
   QUESTION 12
   Find the top 10 sports with the highest number of
   unique athletes.

   Display:
   - Sport
   - Number of Unique Athletes
============================================================*/

SELECT
sport,
COUNT(DISTINCT id) AS number_of_unique_athletes
FROM public.olympic
GROUP BY sport
ORDER BY number_of_unique_athletes DESC
LIMIT 10;


/*============================================================
   QUESTION 13
   Find the Olympic cities that hosted the Olympics more
   than once.

   Display:
   - City
   - Number of Times Hosted
============================================================*/

SELECT
city,
COUNT(DISTINCT games) AS number_of_times_hosted
FROM public.olympic
GROUP BY city
HAVING COUNT(DISTINCT games) > 1
ORDER BY number_of_times_hosted DESC;


/* ============================================================
   🔴 HARD LEVEL
   ============================================================ */


/*============================================================
   QUESTION 14
   Find the top 10 countries/teams with the most medals.

   Display:
   - Team
   - Gold Medals
   - Silver Medals
   - Bronze Medals
   - Total Medals

   Sort by total medals in descending order.
============================================================*/

SELECT
team,
COUNT(*) FILTER ( WHERE medal = 'Gold' ) AS gold_medals,
COUNT(*) FILTER (WHERE medal = 'Silver') AS silver_medals,
COUNT(*) FILTER ( WHERE medal = 'Bronze') AS bronze_medals,
COUNT(medal) AS total_medals
FROM public.olympic
WHERE medal IS NOT NULL
GROUP BY team
ORDER BY total_medals DESC
LIMIT 10;


/*============================================================
   QUESTION 15
   For each Olympic year, find the country/team that won
   the highest number of Gold medals.

   Display:
   - Year
   - Team
   - Gold Medals
============================================================*/

WITH gold_medal_rankings AS (
SELECT
year,
team,
COUNT(*) AS gold_medals,
DENSE_RANK() OVER ( PARTITION BY year ORDER BY COUNT(*) DESC) AS rank
FROM public.olympic
WHERE medal = 'Gold'
GROUP BY
year, 
team
)
SELECT
year,
team,
gold_medals
FROM gold_medal_rankings
WHERE rank = 1
ORDER BY gold_medals DESC;


/*============================================================
   QUESTION 16
   Find athletes who participated in both the Summer and
   Winter Olympics.

   Display:
   - Name
   - Number of Summer Participations
   - Number of Winter Participations
============================================================*/

SELECT
id,
name,
COUNT(*) FILTER (WHERE season = 'Summer') AS summer_participations,
COUNT(*) FILTER (WHERE season = 'Winter') AS winter_participations
FROM public.olympic
GROUP BY id,name
HAVING
COUNT(*) FILTER (WHERE season = 'Summer') > 0
AND
COUNT(*) FILTER (WHERE season = 'Winter') > 0
ORDER BY name;


/*============================================================
   QUESTION 17
   Find the athletes who participated in the highest number
   of different Olympic Games.

   Display:
   - Name
   - Number of Different Games

   Return the Top 10 athletes.
============================================================*/

SELECT
id,
name,
COUNT(DISTINCT games) AS number_of_different_games
FROM public.olympic
GROUP BY
id,
name
ORDER BY number_of_different_games DESC
LIMIT 10;


/*============================================================
   QUESTION 18
   Calculate the medal-winning rate for each team.

   Formula:

   Medal Winning Rate =
   (Medal Winning Participations /
   Total Olympic Participation Records) × 100

   Display:
   - Team
   - Total Participations
   - Medal Winning Participations
   - Medal Winning Rate (%)

   Show the Top 10 teams with the highest rate.
============================================================*/

SELECT
team,
COUNT(*) AS total_participations,
COUNT(medal) AS medal_winning_participations,
ROUND((COUNT(medal)::NUMERIC / COUNT(*)) * 100,2 ) AS medal_winning_rate
FROM public.olympic
GROUP BY team
ORDER BY medal_winning_rate DESC
LIMIT 10;


/*============================================================
   QUESTION 19
   Find the sport in which each country/team won the most
   medals.

   Display:
   - Team
   - Sport
   - Total Medals
============================================================*/
WITH ranked_team_sports AS
(
SELECT
team,
sport,
COUNT(medal) AS total_medals,
DENSE_RANK() OVER ( PARTITION BY team ORDER BY COUNT(medal) DESC) AS rank
FROM public.olympic
WHERE medal IS NOT NULL
GROUP BY
team,
sport
)
SELECT
team,
sport,
total_medals
FROM ranked_team_sports
WHERE rank = 1
ORDER BY team;


/*============================================================
   QUESTION 20
   Create an Olympic Performance Report for each team.

   Display:
   - Team
   - Total Unique Athletes
   - Total Olympic Participations
   - Total Gold Medals
   - Total Silver Medals
   - Total Bronze Medals
   - Total Medals
   - First Year of Participation
   - Last Year of Participation

   Sort by:
   1. Total Gold Medals DESC
   2. Total Medals DESC
============================================================*/

SELECT
team,
COUNT(DISTINCT id) AS total_unique_athletes,
COUNT(*) AS total_olympic_participations,
COUNT(*) FILTER (WHERE medal = 'Gold') AS total_gold_medals,
COUNT(*) FILTER ( WHERE medal = 'Silver') AS total_silver_medals,
COUNT(*) FILTER (WHERE medal = 'Bronze') AS total_bronze_medals,
COUNT(medal) AS total_medals,
MIN(year) AS first_year_of_participation,
MAX(year) AS last_year_of_participation
FROM public.olympic
GROUP BY team
ORDER BY total_gold_medals DESC, total_medals DESC;
/*============================================================
                     🟢END OF PROJECT🟢
 ============================================================*/
