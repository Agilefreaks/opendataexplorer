with source as (
    select 
        scj.numar as numar,
        scj.numarvechi as numar_vechi,
        coalesce(scj.numar, scj.numarvechi) as numar_1,
        scj.obiect as obiect,
        to_date(scj.datainitiala, 'YYYY-MM-DD') as data_initiala,
        stadiuprocesual as stadiu_procesual,
        categoriecaz as categorie_caz,
        stadiulprocesualcombinat as stadiul_procesual_combinat,
        departament
    from {{source('dosare_raw', 'scj')}} scj
    union all
    select
        numar,
        numar_vechi,
        coalesce(numar, numar_vechi) as numar_1,
        obiect,
        to_date(data_initial, 'YYYY-MM-DD') as data_initiala,
        null as stadiu_procesual,
        null as categorie_caz,
        null as stadiul_procesual_combinat,
        null as departament
    from {{source('dosare_raw', 'dosare_just_ro')}} just
)

select distinct *
from source


