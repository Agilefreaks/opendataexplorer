with source as (
    select *
    from {{source('dosare_raw', 'dosare_parti')}}
)

select *
from source