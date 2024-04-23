with source as (
    select 
        to_date(data, 'YYYY-MM-DD') as data,
        ora,
        solutie,
        numar_document,
        numar
    from {{source('dosare_raw', 'sedinte_dosare_just_ro')}}
)

select distinct *
from source