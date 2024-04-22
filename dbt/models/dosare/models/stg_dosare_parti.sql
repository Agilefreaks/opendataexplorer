with source as (
    select
        nume,
        calitateaprocesualacurenta as calitate_parte,
        coalesce(numar, numarvechi) as numar_1,
        to_date(parte.data, 'YYYY-MM-DD') as data,
        calitateaprocesualaanterioara as calitate_parte_anterioara
    from {{source('dosare_raw', 'scj_parti')}} parte
    left join {{source('dosare_raw', 'scj')}} dosar
        on parte._airbyte_scj_hashid = dosar._airbyte_scj_hashid
)

select distinct *
from source

