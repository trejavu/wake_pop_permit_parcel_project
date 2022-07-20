{{ config(materialized='view') }}

with parceldata as 
(
  select *,
  from {{ source('staging','parcels_external_table') }}
)
select
    -- identifiers
    {{ dbt_utils.surrogate_key(['OBJECTID', 'record_date']) }} as id,
    cast(OBJECTID as integer) as objectid,
    cast(CITY as string) as city_code,
    cast({{ get_parcel_translation(CITY) }} as integer) as placecode,
    cast(PLANNING_JURISDICTION as string) as planning_jurisdiction,
    cast(TYPE_USE_DECODE as string) as type_use,
    cast(DESIGN_STYLE_DECODE as string) as design_style,
    cast(LAND_CLASS_DECODE as string) as land_class,
    cast(BLDG_VAL as numeric) as building_value,
    cast(LAND_VAL as numeric) as land_value,
    cast(TOTAL_VALUE_ASSD as string) as total_value,
    cast(TOTUNITS as integer) as total_units,
    cast(record_date as date) as record_date

from parceldata