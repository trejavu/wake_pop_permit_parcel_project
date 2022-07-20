{{ config(materialized='table') }}

with parceldata as 
(
  select *,
  from {{ ref('stg_parcels') }}
  where record_date = (SELECT max(record_date) FROM {{ ref('stg_parcels' )}}) 
),
dim_cities as (
    select * from {{ ref('dim_cities') }}
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
FROM permitdata
JOIN dim_cities ON permitdata.placecode = dim_cities.placecode
GROUP BY 1, 2, 3, 4, 5, 8
