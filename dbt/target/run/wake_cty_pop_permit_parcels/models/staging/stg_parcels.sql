

  create or replace view `de-project-351923`.`dbt_tallison`.`stg_parcels`
  OPTIONS()
  as 

with parceldata as 
(
  select *,
  from `de-project-351923`.`wake_cty_data`.`parcels_external_table`
)
select
    -- identifiers
    to_hex(md5(cast(coalesce(cast(OBJECTID as 
    string
), '') || '-' || coalesce(cast(record_date as 
    string
), '') as 
    string
))) as id,
    cast(OBJECTID as integer) as objectid,
    cast(CITY as string) as city_code,
    cast(case 
        when 'CAR' then 10740
        when 'KNI' then 36080
        when 'WAK' then 70540
        when 'RAL' then 55000
        when 'APE' then 1520
        when 'GAR' then 25480
        when 'HOL' then 32260
        when 'WEN' then 71860
        when 'FUQ' then 25300
        when 'MOR' then 44520
        when 'ZEB' then 76220
        when 'ROL' then 57640
        when '' then 99990
    end as integer) as placecode,
    cast(PLANNING_JURISDICTION as string) as planning_jurisdiction,
    cast(TYPE_USE_DECODE as string) as type_use,
    cast(DESIGN_STYLE_DECODE as string) as design_style,
    cast(LAND_CLASS_DECODE as string) as land_class,
    cast(BLDG_VAL as numeric) as building_value,
    cast(LAND_VAL as numeric) as land_value,
    cast(TOTAL_VALUE_ASSD as string) as total_value,
    cast(TOTUNITS as integer) as total_units,
    cast(record_date as date) as record_date

from parceldata;;

