

  create or replace table `de-project-351923`.`dbt_tallison`.`dim_cities`
  
  
  OPTIONS()
  as (
    


select 
    place as placecode, 
    town, 
    location, 
from `de-project-351923`.`dbt_tallison`.`cities_of_interest`
  );
  