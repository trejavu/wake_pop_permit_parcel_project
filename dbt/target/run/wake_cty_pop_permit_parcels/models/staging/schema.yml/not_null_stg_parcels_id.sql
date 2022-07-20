select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select *
from `de-project-351923`.`dbt_tallison`.`stg_parcels`
where id is null



      
    ) dbt_internal_test