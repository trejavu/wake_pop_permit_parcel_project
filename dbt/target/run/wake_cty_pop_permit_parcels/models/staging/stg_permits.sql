

  create or replace view `de-project-351923`.`dbt_tallison`.`stg_permits`
  OPTIONS()
  as 

with permitdata as 
(
  select *,
  from `de-project-351923`.`wake_cty_data`.`permits_external_table`
  where LOWER(PERMIT_STATUS) NOT IN ('void', 'withdrawn') 
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
    cast(ISSUE_DATE as date) as issue_date,
    cast(PERMIT_STATUS as string) as  permit_status,
    cast(DISTRICT as string) as district,
    cast(case 
        when 'Wake County' then 99990
        when 'Zebulon' then 76220
        when 'Raleigh' then 55000
        when 'Knightdale' then 36080
        when 'Wendell' then 71860
        when 'Rolesville' then 57640
        when 'Cary' then 10740
        when 'Wake Forest' then 70540
        when 'Garner' then 25480
        when 'Morrisville' then 44520
        when 'Apex' then 1520
        when 'Holly Springs' then 32260
        when 'Fuquay Varina' then 25300
    end as integer) as placecode,
    cast(PERMIT_TYPE as string) as permit_type,
    cast(WORK_CLASS as string) as work_class,
    cast(PROPOSED_USE as string) as proposed_use,
    cast(VALUATION as numeric) as valuation,
    cast(TOTAL_FEE_AMOUNT as numeric) as total_fee_amount,
    cast(CONTRACTOR as string) as contractor,
    cast(X as numeric) as longitude,
    cast(Y as numeric) as latitude,
    cast(record_date as date) as record_date

from permitdata;;

