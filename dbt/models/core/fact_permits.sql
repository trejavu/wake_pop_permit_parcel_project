{{ config(materialized='table') }}

with permitdata as 
(
  select *,
  from {{ ref('stg_permits') }}
  where record_date = (SELECT max(record_date) FROM {{ ref('stg_permits' )}}) 
),
dim_cities as (
    select * from {{ ref('dim_cities') }}
)

select
    permitdata.placecode,
    permitdata.issue_date,
    permit_status,
    permit_type,
    proposed_use,
    dim_cities.town jurisdiction,
    count(OBJECTID) permit_count,
    dim_cities.location
FROM permitdata
JOIN dim_cities ON permitdata.placecode = dim_cities.placecode
GROUP BY 1, 2, 3, 4, 5, 6, 8
