
    
    

with dbt_test__target as (
  
  select id as unique_field
  from `de-project-351923`.`dbt_tallison`.`stg_parcels`
  where id is not null
  
)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


