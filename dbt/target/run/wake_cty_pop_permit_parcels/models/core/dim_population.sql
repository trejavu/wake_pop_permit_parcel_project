

  create or replace table `de-project-351923`.`dbt_tallison`.`dim_population`
  
  
  OPTIONS()
  as (
    


select 
    PLACE as placecode, 
    YEAR as year, 
    POPULATION as population, 
from `de-project-351923`.`dbt_tallison`.`wake_pop_data`
  );
  