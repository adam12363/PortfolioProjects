


Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--Showing liklihood of dying from coving in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

--Total cases vs Population 
--Shows what percentage of popualtion got Covid

Select location, date, total_cases, population, (total_cases/population)*100 as TotalPopulationPercentage
From PortfolioProject..CovidDeaths
order by location, date

--Looking at countries with highest infection rate compared to population

Select location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as TotalPopulationPercentage
From PortfolioProject..CovidDeaths
Group By location, population
order by TotalPopulationPercentage desc

-- Showing countries with highest death rate 

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By location
order by TotalDeathCount desc


--Showing continents with highest death rate 

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
Group By location
order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By continent
order by TotalDeathCount desc


--Global numbers per day

Select date, SUM (new_cases) as Total_cases, SUM (cast(new_deaths as int)) as Total_deaths, SUM (cast(new_deaths as int)) / SUM (new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--Total global numbers 

Select  SUM (new_cases) as Total_cases, SUM (cast(new_deaths as int)) as Total_deaths, SUM (cast(new_deaths as int)) / SUM (new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Total population vs vactinations

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_count_of_people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



--CTE 

With PopVsVac (continent, Loaction, Date, PopuLation, New_Vaccinations, Rolling_count_of_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_count_of_people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select * , (Rolling_count_of_people_vaccinated/PopuLation)*100
From PopVsVac



--TEMP TABLE 
DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_count_of_people_vaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_count_of_people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select * , (Rolling_count_of_people_vaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualisations 

USE PortfolioProject
GO
Create VIEW PercentPopulationVaccinatedView4 AS
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_count_of_people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

--VIEW for total global numbers 

USE PortfolioProject
GO 
Create VIEW TotalGlobalNumbers AS
Select  SUM (new_cases) as Total_cases, SUM (cast(new_deaths as int)) as Total_deaths, SUM (cast(new_deaths as int)) / SUM (new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null


--VIEW for Global numbers by day 

USE PortfolioProject
GO
Create VIEW GlobalNumbersByDay AS
Select date, SUM (new_cases) as Total_cases, SUM (cast(new_deaths as int)) as Total_deaths, SUM (cast(new_deaths as int)) / SUM (new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by date

--VIEW for total deaths by region 

USE PortfolioProject 
GO 
Create VIEW TotalDeathCountByRegion AS 
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
Group By location


--View for Countries with the highest death rates

USE PortfolioProject
GO
Create VIEW DeathRateByCountry AS
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By location


--VIEW for infection rate in countires 

USE PortfolioProject
GO
Create VIEW InfectionRateByCountry AS
Select location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as TotalPopulationPercentage
From PortfolioProject..CovidDeaths
Group By location, population


--VIEW for percentage of countries popualtions that caught covid

USE PortfolioProject
GO
Create VIEW PercenatgeOfCountrysPopulationThatCaughtCovid AS
Select location, date, total_cases, population, (total_cases/population)*100 as TotalPopulationPercentage
From PortfolioProject..CovidDeaths

--VIEW to show the liklihood of dying from COVID per Country 

USE PortfolioProject
GO
Create VIEW LikelihoodOfDeathByCovid AS
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths