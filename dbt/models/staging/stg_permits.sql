{{ config(materialized='view') }}

with permitdata as 
(
  select *,
  from {{ source('staging','permits_external_table') }}
  where LOWER(PERMIT_STATUS) NOT IN ('void', 'withdrawn') 
)
select
    -- identifiers
    {{ dbt_utils.surrogate_key(['OBJECTID', 'record_date']) }} as id,
    cast(OBJECTID as integer) as objectid,
    cast(ISSUE_DATE as date) as issue_date,
    cast(PERMIT_STATUS as string) as  permit_status,
    cast(DISTRICT as string) as district,
    cast({{ get_permit_translation(DISTRICT) }} as integer) as placecode,
    cast(PERMIT_TYPE as string) as permit_type,
    cast(WORK_CLASS as string) as work_class,
    cast(PROPOSED_USE as string) as proposed_use,
    cast(VALUATION as numeric) as valuation,
    cast(TOTAL_FEE_AMOUNT as numeric) as total_fee_amount,
    cast(CONTRACTOR as string) as contractor,
    cast(X as numeric) as longitude,
    cast(Y as numeric) as latitude,
    cast(record_date as date) as record_date

from permitdata;
