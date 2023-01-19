# INTRODUCTION
In this project, the task is to derive insights from census data like literacy rate, growth rate, comparison with previous data and male/female composition on different aspects.

A census is a procedure of acquiring records of members of a given population.

# PROJECT TASKS
1. [Data Information.](#data-information)
2. [Total Population.](#total-population)
3. [Average growth rate by state.](#average-growth-rate-by-state)
4. [Average sex ratio by state.](#average-sex-ratio-by-state)
5. [Average literacy rate by state.](#average-literacy-rate-by-state)
6. [States with average literacy rate more than 90.](#states-with-average-literacy-rate-more-than-90)
7. [Top 3 states showing highest growth rate.](#top-3-states-showing-highest-growth-rate)
8. [Bottom 3 states showing lowest sex ratio.](#bottom-3-states-showing-lowest-sex-ratio)
9. [Top and bottom 3 states literacy rate.](#top-and-bottom-3-states-literacy-rate)
10. [Number of males and females.](#number-of-males-and-females)
11. [Number of males and females in a specific district.](#number-of-males-and-females-in-a-specific-district)
12. [State-wise male and female population.](#state-wise-male-and-female-population)
13. [Total literate and illiterate population.](#total-literate-and-illiterate-population)
14. [State-wise literate and illiterate population.](#state-wise-literate-and-illiterate-population)
15. [Growth rate compared with previous and current census data.](#growth-rate-compared-with-previous-and-current-census-data)
16. [State-wise population count in previous and current census data.](#state-wise-population-count-in-previous-and-current-census-data)
17. [Total population in previous and current census.](#total-population-in-previous-and-current-census)
18. [Total population growth rate in previous and current census.](#total-population-growth-rate-in-previous-and-current-census)
19. [Top 3 districts from each state with highest literacy rate.](#top-3-districts-from-each-state-with-highest-literacy-rate)

# Data Information 

```
select*from Data1 --extracting data from Data1
```
![image](https://user-images.githubusercontent.com/90107841/213505630-b00f504d-338e-4f60-931a-58646d01ab27.png)

```
select*from Data2 --extracting data from Data1
```
![image](https://user-images.githubusercontent.com/90107841/213505945-21d9b238-c314-421c-9dfb-46a2c46cadf3.png)

```
--number of rows in dataset 1
select count(*) as num_of_rows_d1 from Data1;
```
![image](https://user-images.githubusercontent.com/90107841/213506298-c5441769-9dee-4ac0-a8c1-38aba56ead60.png)

```
--number of rows in dataset2 
select count(*) as num_of_rows_d2 from Data2;
```
![image](https://user-images.githubusercontent.com/90107841/213507460-0fc6c781-17e7-441c-8254-b682859bf63a.png)

```
--filtering data 2 in which state is Jharkhand and Bihar
select*from Data2 where state in ('Jharkhand','Bihar');
```
![image](https://user-images.githubusercontent.com/90107841/213508024-a3c9ce76-db78-4627-a74b-006310672d21.png)

```
--extract the states having name starting with 'A'
select*from Data1 where [State ] like ('a%');
```
![image](https://user-images.githubusercontent.com/90107841/213508444-6a995e7d-898f-4e59-a7b8-50a5b4d1efeb.png)

```
--extracting only the unique states where state name starts with 'J'
select distinct [State ] from Data1 where [State ] like ('j%');
```
![image](https://user-images.githubusercontent.com/90107841/213508944-9daf9a49-340d-4a94-9a06-c6984279578c.png)

-----------------------------------------------------------------------------------------------------------------------------------------
# Total Population
```
--Summing the population which will give total population
select sum(population) as Population_of_India from data2;
```
![image](https://user-images.githubusercontent.com/90107841/213510900-d69b053b-f6fd-41db-b57d-265e6e894b6f.png)

-----------------------------------------------------------------------------------------------------------------------------------------
# Average growth rate by state
```
--average growth rate by state from data1
select [State ], avg(growth)*100 as average_growth 
from Data1
group by [State ];
```
![image](https://user-images.githubusercontent.com/90107841/213511060-e31d0311-7098-4911-a209-ef98d697c6da.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Average sex ratio by state
```
--average sex ratio according to state
select [State ], round(avg(sex_ratio),0) as average_sex_ratio 
from Data1 group by [State ] order by avg(sex_ratio) desc;
```
![image](https://user-images.githubusercontent.com/90107841/213511806-850ae37e-31ce-4b2b-ab13-e48176a4ada8.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Average literacy rate by state
```
--average literacy rate by state
select [State ],round(avg(literacy),0) as average_literacy_rate from Data1 
group by [State ] order by avg(literacy) desc;
```
![image](https://user-images.githubusercontent.com/90107841/213513026-1bf54bf1-fc6d-4271-8af9-f27cb8f81729.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# States with average literacy rate more than 90.
```
--states with average literacy rate more than 90
select [State ],round(avg(literacy),0) as avg_more_than_90 from Data1 
group by [State ] having round(avg(literacy),0)>90 
order by avg(literacy) desc;
```
![image](https://user-images.githubusercontent.com/90107841/213513280-25d52d99-f801-49ef-b22c-26967de9600b.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Top 3 states showing highest growth rate.
```
--top 3 states showing highest growth rate
select top 3 [State ] as top_states, avg(growth)*100 as growth_rate from Data1
group by [State ] order by avg(growth) desc;

```
![image](https://user-images.githubusercontent.com/90107841/213513721-f938c143-368a-4bce-8b85-d8f2cebcadd3.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Bottom 3 states showing lowest sex ratio.
```
--bottom 3 states showing lowest sex ratio
select top 3 [State ] as  bottom_3, round(avg(Sex_Ratio)*100,0) as growth_rate from Data1
group by [State ] 
order by avg(Sex_Ratio) asc;
```
![image](https://user-images.githubusercontent.com/90107841/213514138-da781c33-6917-401d-8a95-5217db19b485.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Top and bottom 3 states literacy rate.
```
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
```
![image](https://user-images.githubusercontent.com/90107841/213514661-8ce26b3b-6fdb-43f3-b2a8-7e4c95f5042b.png)

```
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
```
![image](https://user-images.githubusercontent.com/90107841/213514791-d9a43bac-8bc7-4ad5-83e5-40e88f5575b8.png)

```
--using union operator to get top and bottom 3 states
select*from (
select top 3 * from #topstates order by top_states desc) as A
union
select*from (
select top 3 * from #bottomstates order by [bottom_states] asc) as B
order by top_states desc;
```
![image](https://user-images.githubusercontent.com/90107841/213514947-2499bbee-842d-4981-ad5c-330dd74a1d52.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Number of males and females
```
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
```
![image](https://user-images.githubusercontent.com/90107841/213515661-df904aa9-c8d9-42e6-99bc-ed3c2058c1a8.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Number of males and females in a specific district
```
--if we want to know the population of males and females in specific district
select z.District, z.Males,z.Females from(
select MF.District,MF.[State ], round(MF.Population/(mf.sex_ratio+1),0) as Males, 
round((mf.Population*(mf.sex_ratio+1))/(mf.sex_ratio+1),0) as Females from(
select D1.District, D1.[State ], D1.Sex_Ratio/1000 as sex_ratio, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as MF ) z where z.District='Thane'; 
```
![image](https://user-images.githubusercontent.com/90107841/213516801-c8a39be2-6ad0-4c0f-809c-8e69c1c7e327.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# State-wise male and female population
```
--for statewise data
select y.[State ], sum(y.Males) as total_males, sum(y.Females)as total_females from( 
select MF.District,MF.[State ], round(MF.Population/(mf.sex_ratio+1),0) as Males, 
round((mf.Population*(mf.sex_ratio+1))/(mf.sex_ratio+1),0) as Females from(
select D1.District, D1.[State ], D1.Sex_Ratio/1000 as sex_ratio, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as MF) as Y
group by y.[State ]
```
![image](https://user-images.githubusercontent.com/90107841/213517426-959ba2d8-991e-4f90-b064-93ac6848c0c7.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Total literate and illiterate population.
```
--total literacy rate
--total literate people= literacy_ratio*population
--total illiterate people=(1-literacy_ratio)*population
--total literate and illiterate population 
select M.District, M.[State ], round(M.literacy_ratio*(M.Population),0) as literate_people,
round((1- M.literacy_ratio)*(M.Population),0) as illterate_people
from (
select D1.District, D1.[State ], D1.Literacy/100 as literacy_ratio, D2.Population from Data1 as D1 
inner join Data2 as D2 
on D1.District=D2.District) M
```
![image](https://user-images.githubusercontent.com/90107841/213518075-9d99b7ae-6a72-4238-a395-d26035ef7160.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# State-wise literate and illiterate population
```
--statewise literate and illiterate population
select U.[State ], sum(U.literate_people) as Literate_People, sum(U.Illterate_people) as Illiterate_People from (
select M.District, M.[State ], round(M.literacy_ratio*(M.Population),0) as literate_people,
round((1- M.literacy_ratio)*(M.Population),0) as Illterate_people
from (
select D1.District, D1.[State ], D1.Literacy/100 as literacy_ratio, D2.Population from Data1 as D1 
inner join Data2 as D2 
on D1.District=D2.District) M ) U
group by U.[State ];
```
![image](https://user-images.githubusercontent.com/90107841/213519061-e943520e-6058-488b-a222-96cf978749dd.png)

-----------------------------------------------------------------------------------------------------------------------------------------
# Growth rate compared with previous and current census data
```
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
```
![image](https://user-images.githubusercontent.com/90107841/213519232-90a7dbc7-c9e0-421c-93a7-c7ec5038284f.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# State-wise population count in previous and current census data
```
--statewise population count in previous and current census data
select o.[State ], sum(o.previous_census_data) as Previous_Data, sum(o.Current_census_data) as Current_data from (
select v.District, v.[State ], round(v.Population/(1+ v.Growth_rate),0) as previous_census_data,
V.Population as Current_census_data, V.Growth_rate as Growth_Rate
from (
select D1.District, D1.[State ], D1.Growth as Growth_rate, D2.Population from Data1 D1
inner join Data2 D2
on D1.District=D2.District ) as V ) as O
group by o.[State ];
```
![image](https://user-images.githubusercontent.com/90107841/213519801-3d9863a9-0563-4704-bc35-cf2a16a6d55b.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Total population in previous and current census
```
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
```
![image](https://user-images.githubusercontent.com/90107841/213520110-92ba8634-cc38-43ea-bd24-fb74a8148351.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Total population growth rate in previous and current census
```
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
```
![image](https://user-images.githubusercontent.com/90107841/213520606-5102cac6-391b-41f9-9ecc-c737884d176c.png)
-----------------------------------------------------------------------------------------------------------------------------------------
# Top 3 districts from each state with highest literacy rate

```
--top 3 districts from each state with highest literacy rate

select A.* from
(select D1.District, D1.[State ], rank() over(partition by State order by literacy desc) as rnk from Data1 D1) as A 
where A.rnk in (1,2,3) order by [State ]
```
![image](https://user-images.githubusercontent.com/90107841/213520995-94977da1-839a-426f-afe1-5de4c77604c3.png)

## **Some of the above snippets are just abstract of output.**

