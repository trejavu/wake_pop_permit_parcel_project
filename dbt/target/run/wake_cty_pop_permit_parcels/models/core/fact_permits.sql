

  create or replace table `de-project-351923`.`dbt_tallison`.`fact_permits`
  
  
  OPTIONS()
  as (
    

with permitdata as 
(
  select *,
  from `de-project-351923`.`dbt_tallison`.`stg_permits`
  where record_date = (SELECT max(record_date) FROM `de-project-351923`.`dbt_tallison`.`stg_permits`) 
),
dim_cities as (
    select * from `de-project-351923`.`dbt_tallison`.`dim_cities`
)

select
    permitdata.placecode,
    permit_status,
    permit_type,
    proposed_use,
    dim_cities.town jurisdiction,
    count(OBJECTID) permit_count,
    dim_cities.location
FROM permitdata
JOIN dim_cities ON permitdata.placecode = dim_cities.placecode
GROUP BY 1, 2, 3, 4, 5, 7
  );
  