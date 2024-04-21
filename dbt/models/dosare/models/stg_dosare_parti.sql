with source as (
    select 
        just.nume,
        just.calitate_parte,
        just.numar,
        scj.data as data,
        scj.calitateaprocesualaanterioara as calitate_parte_anterioara
    from {{source('dosare_raw', 'parti_dosare_just_ro')}} just
    left join {{source('dosare_raw', 'scj_parti')}} scj
        on trim(lower(just.calitate_parte)) = trim(lower(scj.calitateaprocesualacurenta))
        and trim(lower(just.nume)) = trim(lower(scj.nume))
    union all
    select
        nume,
        calitateaprocesualacurenta as calitate_parte,
        null as numar,
        data,
        calitateaprocesualaanterioara as calitate_parte_anterioara
    from {{source('dosare_raw', 'scj_parti')}}
)

select distinct *
from source