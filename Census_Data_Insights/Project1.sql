use Project	

select*from Data1 --extracting data from Data1
select*from Data2 --extracting data from Data1


--number of rows in dataset 1
select count(*) as num_of_rows_d1 from Data1;

--number of rows in dataset2 
select count(*) as num_of_rows_d2 from Data2;

--filtering data 2 in which state is Jharkhand and Bihar
select*from Data2 where state in ('Jharkhand','Bihar');

--Summing the population which will give total population
select sum(population) as Population_of_India from data2;

--average growth rate by state from data1
select [State ], avg(growth)*100 as average_growth 
from Data1
group by [State ];

--average sex ratio according to state
select [State ], round(avg(sex_ratio),0) as average_sex_ratio 
from Data1 group by [State ] order by avg(sex_ratio) desc;

--average literacy rate by state
select [State ],round(avg(literacy),0) as average_literacy_rate from Data1 
group by [State ] order by avg(literacy) desc;

--states with average literacy rate more than 90
select [State ],round(avg(literacy),0) as avg_more_than_90 from Data1 
group by [State ] having round(avg(literacy),0)>90 
order by avg(literacy) desc;

--top 3 states showing highest growth rate
select top 3 [State ] as top_states, avg(growth)*100 as growth_rate from Data1
group by [State ] order by avg(growth) desc;

--bottom 3 states showing lowest sex ratio
select top 3 [State ] as  bottom_3, round(avg(Sex_Ratio)*100,0) as growth_rate from Data1
group by [State ] 
order by avg(Sex_Ratio) asc;

--top and bottom 3 states literacy rate
drop table if exists #topstates -- '#' is for temporary table
create table #topstates 
(
state nvarchar(255), --adding column state
top_states float     --adding column top_states
)
--inserting values in #topstates from table 'Data1'
insert into #topstates
select [State ], round(avg(literacy),0) from Data1 
group by [State ]
order by avg(literacy) desc;
select top 3 * from #topstates order by top_states desc;

--for bottom 3 states
drop table if exists #bottomstates
create table #bottomstates 
(
[state] nvarchar(255),
[bottom_states] float
)
insert into #bottomstates
select [State ], round(avg(literacy),0) from Data1 
group by [State ]
order by avg(literacy) desc;
select top 3 * from #bottomstates order by bottom_states asc;

--using union operator to get top and bottom 3 states
select*from (
select top 3 * from #topstates order by top_states desc) as A
union
select*from (
select top 3 * from #bottomstates order by [bottom_states] asc) as B
order by top_states desc;

--extract the states having name starting with 'A'
select*from Data1 where [State ] like ('a%');

--extracting only the unique states where state name starts with 'J'
select distinct [State ] from Data1 where [State ] like ('j%');

--joining data1 and data2 using inner join
select D1.District, D1.[State ], D1.Sex_Ratio, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District

--formula used to calculate males and females
--female/male=sex_ratio ....1
--female+male=population ...2
--female=population-male ...3 (substituting the eq3 in eq1)
--population-male=(sex_ratio)*male
--population=male(sex_ratio+1) 
--male=population/(sex_ratio +1) ....for males
--from eq 3 
--female=population-population/(sex_ratio+1)
--female=(population*(sex_ratio+1))/(sex_ratio+1) ...for female

--using subquery to calculate the no. of males and females

select MF.District,MF.[State ], round(MF.Population/(mf.sex_ratio+1),0) as Males, 
round((mf.Population*(mf.sex_ratio+1))/(mf.sex_ratio+1),0) as Females from(
select D1.District, D1.[State ], D1.Sex_Ratio/1000 as sex_ratio, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as MF; --MF is alias for subquery

--if we want to know the population of males and females in specific district
select z.District, z.Males,z.Females from(
select MF.District,MF.[State ], round(MF.Population/(mf.sex_ratio+1),0) as Males, 
round((mf.Population*(mf.sex_ratio+1))/(mf.sex_ratio+1),0) as Females from(
select D1.District, D1.[State ], D1.Sex_Ratio/1000 as sex_ratio, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as MF ) z where z.District='Thane'; 

--for statewise data
select y.[State ], sum(y.Males) as total_males, sum(y.Females)as total_females from( 
select MF.District,MF.[State ], round(MF.Population/(mf.sex_ratio+1),0) as Males, 
round((mf.Population*(mf.sex_ratio+1))/(mf.sex_ratio+1),0) as Females from(
select D1.District, D1.[State ], D1.Sex_Ratio/1000 as sex_ratio, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as MF) as Y
group by y.[State ]

--total literacy rate
--total literate people= literacy_ratio*population
--total illiterate people=(1-literacy_ratio)*population

select M.District, M.[State ], round(M.literacy_ratio*(M.Population),0) as literate_people,
round((1- M.literacy_ratio)*(M.Population),0) as illterate_people
from (
select D1.District, D1.[State ], D1.Literacy/100 as literacy_ratio, D2.Population from Data1 as D1 
inner join Data2 as D2 
on D1.District=D2.District) M

--statewise literate and illiterate population
select U.[State ], sum(U.literate_people) as Literate_People, sum(U.Illterate_people) as Illiterate_People from (
select M.District, M.[State ], round(M.literacy_ratio*(M.Population),0) as literate_people,
round((1- M.literacy_ratio)*(M.Population),0) as Illterate_people
from (
select D1.District, D1.[State ], D1.Literacy/100 as literacy_ratio, D2.Population from Data1 as D1 
inner join Data2 as D2 
on D1.District=D2.District) M ) U
group by U.[State ];

--population in previous census
--previous_census +growth*previous_census =population
--previous_census=population/(1+growth) ...1

--growth rate compared with previous and current census data
select v.District, v.[State ], round(v.Population/(1+ v.Growth_rate),0) as previous_census_data,
V.Population as Current_census_data, V.Growth_rate as Growth_Rate
from (
select D1.District, D1.[State ], D1.Growth as Growth_rate, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as V;


--statewise population count in previous and current census data
select o.[State ], sum(o.previous_census_data) as Previous_Data, sum(o.Current_census_data) as Current_data from (
select v.District, v.[State ], round(v.Population/(1+ v.Growth_rate),0) as previous_census_data,
V.Population as Current_census_data, V.Growth_rate as Growth_Rate
from (
select D1.District, D1.[State ], D1.Growth as Growth_rate, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as V ) as O
group by o.[State ];

--total poulation of india in previous and current census
select sum(L.Previous_Data) as Previous_Census_Population, sum(L.Current_data) as Current_census_Population from (
select o.[State ], sum(o.previous_census_data) as Previous_Data, sum(o.Current_census_data) as Current_data from (
select v.District, v.[State ], round(v.Population/(1+ v.Growth_rate),0) as previous_census_data,
V.Population as Current_census_data, V.Growth_rate as Growth_Rate
from (
select D1.District, D1.[State ], D1.Growth as Growth_rate, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as V ) as O
group by o.[State ] ) as L;

--total poulation growth rate of india in previous and current census
select P.Previous_Census_Population as Prev_Population, 
P.Current_census_Population as Current_Population,
(P.Previous_Census_Population/P.Current_census_Population) as Growth_Rate from (
select sum(L.Previous_Data) as Previous_Census_Population, sum(L.Current_data) as Current_census_Population from (
select o.[State ], sum(o.previous_census_data) as Previous_Data, sum(o.Current_census_data) as Current_data from (
select v.District, v.[State ], round(v.Population/(1+ v.Growth_rate),0) as previous_census_data,
V.Population as Current_census_data, V.Growth_rate as Growth_Rate
from (
select D1.District, D1.[State ], D1.Growth as Growth_rate, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as V ) as O
group by o.[State ] ) as L ) as P

--top 3 districts from each state with highest literacy rate

select A.* from
(select D1.District, D1.[State ], rank() over(partition by State order by literacy desc) as rnk from Data1 D1) as A 
where A.rnk in (1,2,3) order by [State ]
