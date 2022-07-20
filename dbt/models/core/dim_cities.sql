{{ config(materialized='table') }}


select 
    place as placecode, 
    town, 
    location, 
from {{ ref('cities_of_interest') }}