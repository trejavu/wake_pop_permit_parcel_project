{{ config(materialized='table') }}


select 
    PLACE as placecode, 
    YEAR as year, 
    POPULATION as population, 
from {{ ref('wake_pop_data') }}