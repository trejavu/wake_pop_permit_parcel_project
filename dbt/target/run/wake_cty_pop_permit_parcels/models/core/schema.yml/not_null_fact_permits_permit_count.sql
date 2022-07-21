select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select *
from `de-project-351923`.`dbt_tallison`.`fact_permits`
where permit_count is null



      
    ) dbt_internal_test