 {#
    This macro returns the place code of given place identifier 
#}

{% macro get_permit_translation(district) -%}

    case
        when {{ district }} = 'Wake County' then 99990
        when {{ district }} = 'Zebulon' then 76220
        when {{ district }} = 'Raleigh' then 55000
        when {{ district }} = 'Knightdale' then 36080
        when {{ district }} = 'Wendell' then 71860
        when {{ district }} = 'Rolesville' then 57640
        when {{ district }} = 'Cary' then 10740
        when {{ district }} = 'Wake Forest' then 70540
        when {{ district }} = 'Garner' then 25480
        when {{ district }} = 'Morrisville' then 44520
        when {{ district }} = 'Apex' then 1520
        when {{ district }} = 'Holly Springs' then 32260
        when {{ district }} = 'Fuquay Varina' then 25300
    end

{%- endmacro %}

{% macro get_parcel_translation(city) -%}

    case
        when {{ city }} = 'CAR' then 10740
        when {{ city }} = 'KNI' then 36080
        when {{ city }} = 'WAK' then 70540
        when {{ city }} = 'RAL' then 55000
        when {{ city }} = 'APE' then 1520
        when {{ city }} = 'GAR' then 25480
        when {{ city }} = 'HOL' then 32260
        when {{ city }} = 'WEN' then 71860
        when {{ city }} = 'FUQ' then 25300
        when {{ city }} = 'MOR' then 44520
        when {{ city }} = 'ZEB' then 76220
        when {{ city }} = 'ROL' then 57640
        when {{ city }} IS NULL then 99990
    end

{%- endmacro %}



              