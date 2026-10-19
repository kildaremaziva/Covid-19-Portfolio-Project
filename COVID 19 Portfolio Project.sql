
select *
from CovidDeaths
order by 3,4
;

select *
from CovidVaccinations
order by 3,4
;

-- select the data we are going to be using 

select location,continent, date, total_cases,new_cases,total_deaths, population
from CovidDeaths
order by 1,2
;

-- looking at Total cases vs Total deaths 
-- shows the likelyhood of death if you contract covid in your country

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths
where location like '%zimbabwe%'
order by 1,2
;

-- Total cases vs total population 
-- shows what percentage of the population got covid 

select location, date, population, total_cases, (total_cases/population)*100 as percentinfected
from CovidDeaths
where location like '%zimbabwe%'
order by 1,2
;


-- Looking at countries with highest infection rate comapred to population

select location,continent,population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpoulationinfected
from CovidDeaths
group by location, population, continent
order by percentpoulationinfected desc;

-- showing countries with the highest death count per population 

select location,continent,max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is not null
group by location, continent
order by totaldeathcount desc
;

-- LETS BREAK THINGS DOWN BY CONTINENT
-- showing continents with the highest death count 

select continent,max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc
;

-- Global Numbers 

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as perctangeofdeathglobal
from CovidDeaths
where continent is not null
group by date
order by 1,2
;

-- looking at total Population vs Vaccinations 

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as rollingpeoplevaccinated
-- (rollingpeoplevaccinated/population)
from CovidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2, 3
	;

	-- using a cte 

	with popvsvac (continent, locaion, date, population,new_vaccinations, rollingpeoplevaccinated)
	as
	(
	select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as rollingpeoplevaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2, 3
	)
	select *, (rollingpeoplevaccinated/population)*100
	from popvsvac

	-- creating view to store data for later visualizations 

	create view percentpopulationvaccinated as
	with popvsvac (continent, location, date, population,new_vaccinations, rollingpeoplevaccinated)
	as
	(
	select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as rollingpeoplevaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2, 3
	)
	select *, (rollingpeoplevaccinated/population)*100 as percentrollingvacinated 
	from popvsvac

	select*
	from percentpopulationvaccinated

























