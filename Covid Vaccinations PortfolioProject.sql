SELECT *
From PortfolioProject..CovidDeaths
Order by 3,4

SELECT *
From PortfolioProject..CovidVaccinations
Order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2

SELECT location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
From PortfolioProject..CovidDeaths
--where location like 'India'
order by 1,2

SELECT location, population, MAX(total_cases), MAX((total_cases/population))*100 as InfectedPercentage
From PortfolioProject..CovidDeaths
--where location like 'India'
group by location, population
order by InfectedPercentage desc


select location, MAX(cast(total_deaths as int)) as TotalDeathCounts From PortfolioProject..CovidDeaths
where continent is not NULL
group by location
order by TotalDeathCounts desc

-- data set indicating correct value
select location, MAX(cast(total_deaths as int)) as TotalDeathCounts From PortfolioProject..CovidDeaths
where continent is NULL
group by location
order by TotalDeathCounts desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCounts From PortfolioProject..CovidDeaths
where continent is not NULL
group by continent
order by TotalDeathCounts desc

select date, sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From PortfolioProject..CovidDeaths
where continent is not NULL
group by date
order by 1,2

select sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From PortfolioProject..CovidDeaths
where continent is not NULL
-- group by date
order by 1,2

-- JOINS and some calucations

Select *
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location)
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL
order by 2,3

-- USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL
-- order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100 as VacPercentage
from PopvsVac

-- creating view for later visualizations

create view PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not NULL
-- order by 2,3

Select * 
from PercentagePopulationVaccinated