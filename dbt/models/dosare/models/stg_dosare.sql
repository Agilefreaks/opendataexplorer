with source as (
    select 
        scj.numar as numar,
        scj.numarvechi as numar_vechi,
        scj.obiect as obiect,
        scj.datainitiala as data_initiala,
        stadiuprocesual as stadiu_procesual,
        categoriecaz as categorie_caz,
        stadiulprocesualcombinat as stadiul_procesual_combinat,
        departament
    from {{source('dosare_raw', 'scj')}} scj
    union all
    select
        numar,
        numar_vechi,
        obiect,
        data_initial as data_initiala,
        null as stadiu_procesual,
        null as categorie_caz,
        null as stadiul_procesual_combinat,
        null as departament
    from {{source('dosare_raw', 'dosare_just_ro')}} just
)

select distinct *
from source