-- Data we are going to use
select
	location, date, total_cases, new_cases, population
FROM 
	covid_analysis.covid_deaths;
    
-- Total case vs death case

SELECT
	location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM
	covid_analysis.covid_deaths
ORDER BY 1,2;

-- total cases vs population

SELECT
	location, date, total_cases, population, (total_cases/population)*100 AS infected_rate
FROM
	covid_analysis.covid_deaths
ORDER BY 1,2;

-- Looking for highest infection rate compared to population

SELECT
	location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percentage_population_infected
FROM
	covid_analysis.covid_deaths
GROUP BY location, population
ORDER BY percentage_population_infected DESC;

-- Countries with highest death count per population

SELECT
	location, population, MAX(total_deaths) AS total_death_count
FROM
	covid_analysis.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY total_death_count DESC;

-- Let's break things down by Continents

SELECT
	continent, MAX(total_deaths) AS total_death_count
FROM
	covid_analysis.covid_deaths
GROUP BY continent
ORDER BY total_death_count DESC;

-- Showing continents with the highest death count per population

SELECT
	continent, MAX(total_deaths) AS total_death_count
FROM
	covid_analysis.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Global Numbers

SELECT 
	SUM(total_cases), SUM(new_deaths), SUM(new_deaths)/SUM(total_cases)*100 AS death_percentage
FROM
	covid_analysis.covid_deaths
WHERE continent IS NOT NULL
order by death_percentage DESC;

-- Total Population vs Vaccination


SELECT 
	covid_analysis.covid_deaths.continent, covid_analysis.covid_deaths.location,covid_analysis.covid_deaths.date, 
    population, covid_analysis.covid_vaccinations.new_vaccinations, 
    SUM(covid_analysis.covid_vaccinations.new_vaccinations) OVER (partition by covid_analysis.covid_vaccinations.location) AS vaccination_by_location,
    (vaccination_by_location/population)*100
FROM covid_analysis.covid_deaths
JOIN covid_analysis.covid_vaccinations
ON covid_analysis.covid_deaths.location = covid_analysis.covid_vaccinations.location
AND covid_analysis.covid_deaths.date = covid_analysis.covid_vaccinations.date
WHERE covid_analysis.covid_deaths.continent IS NOT NULL
order by 2,3;