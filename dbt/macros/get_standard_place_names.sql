 {#
    This macro returns the description of the payment_type 
#}

{% macro get_permit_translation(district) -%}

    case {{ district }}
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
    end

{%- endmacro %}

{% macro get_parcel_translation(city) -%}

    case {{ city }}
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
    end

{%- endmacro %}



              