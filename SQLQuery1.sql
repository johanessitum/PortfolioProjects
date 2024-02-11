--Select *
--From PortfolioProject..CovidDeaths
--order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using




Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Show the likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths)/NULLIF(CONVERT(float, total_cases),0))*100 as DeathPrecentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2



-- Looking at Total Cases vs Population
-- Precentage of population got Covid
Select location, date, total_cases, population, (CONVERT(float, total_cases)/NULLIF(CONVERT(float, population),0))*100 as CovidPrecentage
From PortfolioProject..CovidDeaths
Where location like '%Indonesia%'
order by 1,2


-- Looking at Countries wuth Highest Infection Rate
Select location, population, MAX(total_cases) AS HighestInfectionCount, population, Max((CONVERT(float, total_cases)/NULLIF(CONVERT(float, population),0)))*100 as CovidPrecentage
From PortfolioProject..CovidDeaths
--Where location like '%Indonesia%'
Group by location, population
order by CovidPrecentage desc

-- showing countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as float)) AS Totaldeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by Totaldeathcount desc

-- Breaking down by continent
Select continent, sum(cast(new_deaths as float)) AS Totaldeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by Totaldeathcount desc

-- Breaking down by continent
Select location, Max(cast(total_deaths as float)) AS Totaldeathcount
From PortfolioProject..CovidDeaths  
Where continent is null
Group by location
order by Totaldeathcount desc

-- global numbers

Select date SUM(cast(new_cases AS float)) as total_cases, SUM(cast(new_deaths as float)), sum(convert(float, new_deaths))/sum(nullif(convert(float,new_cases),0))*100 as DeathPrecentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

-- Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3