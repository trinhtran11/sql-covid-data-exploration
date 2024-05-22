-- VIEW SAMPLES OF 2 TABLES
SELECT *
FROM covid_deaths cd
ORDER BY 3,4
LIMIT 10

SELECT *
FROM covid_vaccinations cv
ORDER BY 3,4
LIMIT 10


-- EXPLORING DATA

-- View values in location column
SELECT DISTINCT location, continent 
FROM covid_deaths cd 

-- Some records having empty string in continent column -> Validate these records
SELECT DISTINCT location, continent 
FROM covid_deaths cd 
WHERE cd.continent = ''
 
-- View total cases and deaths by continent
SELECT continent
	, MAX(total_cases) as highest_infection_count
	, MAX(new_cases) as highest_new_cases
	, MAX(total_deaths) as highest_deaths
	, MAX((total_deaths/population)*100) as highest_mortality_rate
FROM covid_deaths cd 
-- Remove subtotal rows of whole regions or income classes and null cases
WHERE cd.continent != ''
GROUP BY continent
HAVING highest_infection_count IS NOT NULL

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as pct_infected
FROM covid_deaths cd
-- Remove stats data of whole continents or regions
WHERE cd.continent != '' 
GROUP BY location, population
ORDER BY pct_infected DESC


-- Showing Countries with Highest Deaths
SELECT location, population, MAX(total_deaths) as highest_deaths, MAX(total_deaths/population)*100 as mortality_rate
FROM covid_deaths cd
-- Remove stats data of whole continents or regions
WHERE cd.continent != '' 
GROUP BY location, population
ORDER BY mortality_rate DESC

-- Showing global number
SELECT location, date, population, total_cases, new_cases, total_deaths, new_deaths
	,CASE WHEN total_cases = 0
	THEN 0
	ELSE (total_deaths/population)*100
	END as mortality_rate
	,YEAR(cd.`date`) as `year`
	,MONTH(cd.`date`) as `month`
FROM covid_deaths cd 
WHERE location = 'World'
ORDER BY 2 asc

-- New vaccinations worldwide
SELECT cd.continent , cd.location, cd.date, cd.population
		, cv.new_vaccinations 
		, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as rolling_people_vaccinated
FROM covid_deaths cd 
JOIN covid_vaccinations cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent != ''
AND cv.new_vaccinations IS NOT NULL
ORDER BY 2,3


-- Using CTE
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS (
SELECT cd.continent , cd.location, cd.date, cd.population
		, cv.new_vaccinations 
		, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as rolling_people_vaccinated
FROM covid_deaths cd 
JOIN covid_vaccinations cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent != ''
ORDER BY 2,3
)
SELECT *
	, (rolling_people_vaccinated/population)*100 as vaccinated_vs_population
FROM pop_vs_vac


-- Using TEMP TABLE
DROP TABLE IF EXISTS new_pop_vaccinated;

CREATE TABLE new_pop_vaccinated (
continent VARCHAR(255), 
location VARCHAR(255), 
date DATETIME,
population DOUBLE,
new_vaccinations DOUBLE,
rolling_people_vaccinated DOUBLE
);

INSERT INTO new_pop_vaccinated (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
SELECT cd.continent , cd.location, cd.date, cd.population
		, cv.new_vaccinations 
		, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as rolling_people_vaccinated
FROM covid_deaths cd 
JOIN covid_vaccinations cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent != '';

SELECT *
FROM new_pop_vaccinated;


-- LET'S REVIEW THE DATA OF VIETNAM

-- Looking at Total Cases vs Total Deaths
SELECT location, date, total_deaths
		, (total_deaths/total_cases)*100 as death_per_infection
		, (total_deaths/population)*100 as mortality_rate
FROM covid_deaths cd
-- Remove stats data of whole continents or regions
WHERE cd.continent != '' 
AND location like '%viet%'
AND total_cases IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Population, percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as pct_infected
FROM covid_deaths cd
-- Remove stats data of whole continents or regions
WHERE cd.continent != '' 
AND location like '%viet%'
AND total_cases IS NOT NULL
ORDER BY 1,2

-- Create view to store data for later visualization
CREATE VIEW continent_data as (
SELECT continent
	, MAX(total_cases) as highest_infection_count
	, MAX(new_cases) as highest_new_cases
	, MAX(total_deaths) as highest_deaths
	, MAX((total_deaths/population)*100) as highest_mortality_rate
FROM covid_deaths cd 
-- Remove subtotal rows of whole regions or income classes and null cases
WHERE cd.continent != ''
GROUP BY continent
HAVING highest_infection_count IS NOT NULL
)

SELECT *
FROM continent_data


CREATE VIEW pct_pop_vaccinated as (
SELECT cd.continent , cd.location, cd.date, cd.population
		, cv.new_vaccinations 
		, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as rolling_people_vaccinated
FROM covid_deaths cd 
JOIN covid_vaccinations cv 
	ON cd.location = cv.location 
	AND cd.date = cv.date
WHERE cd.continent != '')

SELECT *
FROM pct_pop_vaccinated

