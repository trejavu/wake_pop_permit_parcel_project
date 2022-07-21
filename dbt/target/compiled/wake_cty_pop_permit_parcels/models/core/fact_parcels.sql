

with parceldata as 
(
  select *,
  from `de-project-351923`.`dbt_tallison`.`stg_parcels`
  where record_date = (SELECT max(record_date) FROM `de-project-351923`.`dbt_tallison`.`stg_parcels`) 
),
dim_cities as (
    select * from `de-project-351923`.`dbt_tallison`.`dim_cities`
)

select
    parceldata.placecode,
    type_use,
    design_style,
    land_class,
    dim_cities.town jurisdiction,
    count(OBJECTID) parcel_count,
    SUM(total_units) unit_count,
    dim_cities.location
FROM parceldata
JOIN dim_cities ON parceldata.placecode = dim_cities.placecode
GROUP BY 1, 2, 3, 4, 5, 8