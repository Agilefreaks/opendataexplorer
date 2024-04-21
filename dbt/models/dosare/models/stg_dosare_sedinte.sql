with source as (
    select 
        data,
        ora,
        solutie,
        numar_document,
        numar
    from {{source('dosare_raw', 'sedinte_dosare_just_ro')}}
)

select distinct *
from source