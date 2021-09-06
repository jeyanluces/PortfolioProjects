--SELECT *
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--ORDER BY 3, 4

--SELECT *
--FROM PortfolioProject..CovidVacinations

-----Selecting the data to be used
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--ORDER BY 1, 2

---Looking at the Total Cases VS Total Deaths
--SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%' 
--AND continent is not NULL
--ORDER BY 1, 2 DESC

--Looking at the Total Cases VS Population
--SELECT location, date, population, total_cases, ((total_cases/population)*100) AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states%' AND continent is not NULL
--ORDER BY 1, 2 

--Countries highest infection rate compared to its population
--SELECT location, population, MAX(total_cases) AS HighestInfectionCase, MAX(((total_cases/population))*100) AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY location, population
--ORDER BY PercentPopulationInfected DESC

----Shows the countries with highest death count per population
--SELECT location, population, MAX(cast(total_deaths AS int)) AS TotalDeathCount, MAX(((total_deaths/population))*100) AS PercentDeathPerPopulation
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY location, population
--ORDER BY PercentDeathPerPopulation DESC

----Literal numbers of death count per country (including continents)
--SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC

--Looking at per "continent" in total (based on the column names of the data)
SELECT continent, sum(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

----Looking at per "country/location" in total (based on the column names of the data) -  World, European Union, International NOT included
SELECT location, sum(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is  NULL AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location 
ORDER BY TotalDeathCount DESC

--Total Global Numbers by date
--SELECT date, SUM(new_cases) AS NewCases, SUM(CAST(new_deaths AS INT)) AS NewDeaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100) AS NewPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 2 DESC, 3 DESC

--Total Global Numbers (just numbers)
--SELECT SUM(new_cases) AS NewCases, SUM(CONVERT(INT, new_deaths)) AS NewDeaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100) AS NewPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--ORDER BY 2 DESC, 3 DESC

--Total Vaccination VS Population (joining two tables)
--Rolling count
--Only shows filled columns
--SELECT dea.continent
--			, dea.location
--			, dea.date
--			, dea.population
--			, CONVERT(INT, vac.new_vaccinations) AS PeopleVaccinatedPerDay
--			, SUM(CONVERT(INT, vac.new_vaccinations))
--			OVER(PARTITION BY dea.location											  --the goal is that the SUM will start over every location
--			ORDER BY dea.location, dea.date) AS TotalPeopleVaccinated --will show newVaccinations adding to totalVaccinations per date
--FROM PortfolioProject..CovidVacinations as vac 
--JOIN PortfolioProject..CovidDeaths as dea
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL 
--ORDER BY 2, 3

--Total Vaccination VS Population (joining two tables)
--Rolling count
--SELECT dea.continent
--			, dea.location
--			, dea.date
--			, dea.population
--			, CONVERT(INT, vac.new_vaccinations) AS PeopleVaccinatedPerDay
--			, SUM(CONVERT(INT, vac.new_vaccinations))
--			OVER(PARTITION BY dea.location											  --the goal is that the SUM will start over every location
--			ORDER BY dea.location, dea.date) AS TotalPeopleVaccinated --will show newVaccinations adding to totalVaccinations per date
--FROM PortfolioProject..CovidVacinations AS vac 
--JOIN PortfolioProject..CovidDeaths AS dea
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL 
--ORDER BY 2, 3

--Using CTE (common table expression) - temporary named result set from query (will use temp column)
---the # of columns mentioned on the SELECT query must be mentioned here as well
--With PopsVsVac (
--		Continent 
--		, Location 
--		, Date
--		, Population
--		, New_Vaccinations
--		, TotalPeopleVaccinated ) 
--AS (
--SELECT dea.continent
--			, dea.location
--			, dea.date
--			, dea.population
--			, CONVERT(INT, vac.new_vaccinations) AS PeopleVaccinatedPerDay
--			, SUM(CONVERT(INT, vac.new_vaccinations))
--			OVER(PARTITION BY dea.location											  --the goal is that the SUM will start over every location
--			ORDER BY dea.location, dea.date) AS TotalPeopleVaccinated --will show newVaccinations adding to totalVaccinations per date
--FROM PortfolioProject..CovidVacinations AS vac 
--JOIN PortfolioProject..CovidDeaths AS dea
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL 
----ORDER BY 2, 3
--)
----Will show the percent of people vaccinated per population
--SELECT *, (TotalPeopleVaccinated/Population)*100 AS PercentPeopleVaccinated
--FROM PopsVsVac;

--Using Temp Table (create a new table, 
--Same result, different method

-- Creating View to store data for later visualizations
--CREATE VIEW PercentPopulationVaccinated AS
--SELECT dea.continent
--			, dea.location
--			, dea.date
--			, dea.population
--			, CONVERT(INT, vac.new_vaccinations) AS PeopleVaccinatedPerDay
--			, SUM(CONVERT(INT, vac.new_vaccinations))
--			OVER(PARTITION BY dea.location											  --the goal is that the SUM will start over every location
--			ORDER BY dea.location, dea.date) AS TotalPeopleVaccinated --will show newVaccinations adding to totalVaccinations per date
--FROM PortfolioProject..CovidVacinations AS vac 
--JOIN PortfolioProject..CovidDeaths AS dea
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL;