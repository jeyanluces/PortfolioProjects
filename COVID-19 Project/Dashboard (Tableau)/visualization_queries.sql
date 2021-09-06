---- View 1 > shows TotalCases, TotalDeaths & Percentage
--SELECT SUM (new_cases) AS TotalCases
--	, SUM(CAST(new_deaths AS INT)) AS TotalDeaths
--	, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--ORDER BY 1, 2;

---- View 2 > total death count all over the world
--SELECT location
--			, SUM(CAST	(total_deaths AS INT)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NULL
--		AND location NOT IN ('World', 'European Union', 'International')
--GROUP BY location
--ORDER BY TotalDeathCount DESC;

-- View 3 > PercentPopulationInfected
--SELECT location
--			, population
--			, MAX(total_cases) AS HighestInfectionRate
--			, MAX((total_cases/population))*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
--GROUP BY location, population
--ORDER BY PercentPopulationInfected DESC;

-- View 4 > PercentPopulationInfected
SELECT location
			, population
			, date
			, MAX(total_cases) AS HighestInfectionCount
			, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC