with source as (
    select *
    from {{source('dosare_raw', 'dosare')}}
)

select *
from source