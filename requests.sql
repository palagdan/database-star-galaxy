-- Seznam zaměstnanců,kteří žijí v Praze.
SELECT z.jmeno 
from 
zamestnanec z join adresa a on z.id_adresa=a.id_adresa
where a.mesto='Prague'

-- Seznam planet v systému Polaris.
SELECT DISTINCT nazev
FROM (
    SELECT DISTINCT id_soustava AS k1,
                    nazev
    FROM PLANETA
) R1
JOIN (
    SELECT DISTINCT id_soustava AS k2
    FROM SOUSTAVA
    WHERE SOUSTAVA.nazev = 'Polaris'
) R2 ON k1 = k2;

-- Seznam lodí , které nelétaly do planety Mars.
SELECT DISTINCT *
FROM (
    SELECT DISTINCT id_lod
    FROM LOD
    EXCEPT (
        SELECT DISTINCT id_lod
        FROM (
            SELECT DISTINCT id_lod,
                            id_planeta
            FROM EXKURZE
        ) R1
        EXCEPT
        SELECT DISTINCT id_lod
        FROM (
            SELECT DISTINCT *
            FROM (
                SELECT DISTINCT id_lod
                FROM (
                    SELECT DISTINCT id_lod,
                                    id_planeta
                    FROM EXKURZE
                ) R1
            ) R2
            CROSS JOIN (
                SELECT DISTINCT id_planeta
                FROM PLANETA
                WHERE nazev = 'Mars'
            ) R3
            EXCEPT
            SELECT DISTINCT id_lod,
                            id_planeta
            FROM EXKURZE
        ) R4
    )
) R5
NATURAL JOIN LOD LOD1;


-- Najdi objednavky, obsahujících službu typu Fotografie a videa.
SELECT DISTINCT *
FROM (
    SELECT DISTINCT id_objednavka
    FROM OBJEDNAVKA
    NATURAL JOIN SLUZBA_OBJEDNAVKA
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM TYP_SLUZBA
        WHERE popis = 'Fotografie a videa'
    ) R1
    NATURAL JOIN SLUZBA
) R2
NATURAL JOIN OBJEDNAVKA OBJEDNAVKA1;

-- Seznam konzultantů, kteří vyřizovali objednávky v roce 2019.
SELECT DISTINCT jmeno
FROM (
    SELECT DISTINCT id_zam
    FROM (
        SELECT DISTINCT id_zam
        FROM KONZULTANT
    ) R1
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM OBJEDNAVKA
        WHERE datum >= TO_DATE('1.1.2019','dd.mm.yyyy') AND datum <= TO_DATE('31.12.2019','dd.mm.yyyy')
    ) R2
) R3
NATURAL JOIN ZAMESTNANEC;

-- Najdi lodi, které létaly do všech planet.
select * from lod where not exists
    (
    select * from planeta where not exists(
        
        select * from exkurze where lod.id_lod = exkurze.id_lod and planeta.id_planeta = exkurze.id_planeta
        )
    );
 -- Seznam suvenýrů, které prodal pouze zaměstnanec Jakub Novák.
 SELECT DISTINCT *
FROM (
    SELECT DISTINCT id_sluzba
    FROM OBJEDNAVKA
    NATURAL JOIN SLUZBA_OBJEDNAVKA
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM TYP_SLUZBA
        WHERE popis = 'Suvenyr'
    ) R1
    NATURAL JOIN SLUZBA
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM ZAMESTNANEC
        WHERE jmeno = 'Jakub' AND prijmeni = 'Novák'
    ) R2
    EXCEPT
    SELECT DISTINCT id_sluzba
    FROM OBJEDNAVKA OBJEDNAVKA1
    NATURAL JOIN SLUZBA_OBJEDNAVKA SLUZBA_OBJEDNAVKA1
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM TYP_SLUZBA TYP_SLUZBA1
        WHERE popis = 'Suvenyr'
    ) R3
    NATURAL JOIN SLUZBA SLUZBA1
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM ZAMESTNANEC ZAMESTNANEC1
        WHERE jmeno != 'Jakub' AND prijmeni != 'Novák'
    ) R4
) R5
NATURAL JOIN SUVENYR;
-- Konzultanty, kteří někdy vyřizovali typ služby “Suvenýr” a “Fotografie a videa”.
SELECT DISTINCT jmeno
FROM (
    SELECT DISTINCT id_zam,
                    id_adresa,
                    osobni_cislo,
                    jmeno,
                    prijmeni,
                    telefon
    FROM ZAMESTNANEC
    NATURAL JOIN (
        SELECT DISTINCT id_zam
        FROM KONZULTANT
        NATURAL JOIN (
            SELECT DISTINCT id_objednavka,
                            id_zam,
                            id_zakaznik,
                            cena,
                            datum
            FROM OBJEDNAVKA
            NATURAL JOIN (
                SELECT DISTINCT id_sluzba,
                                id_objednavka
                FROM SLUZBA_OBJEDNAVKA
                NATURAL JOIN (
                    SELECT DISTINCT id_sluzba,
                                    id_typ_sluzba
                    FROM SLUZBA
                    NATURAL JOIN (
                        SELECT DISTINCT *
                        FROM TYP_SLUZBA
                        WHERE popis = 'Suvenyr'
                    ) R1
                ) R2
            ) R3
        ) R4
    ) R5
) R6
INTERSECT
SELECT DISTINCT jmeno
FROM (
    SELECT DISTINCT id_zam,
                    id_adresa,
                    osobni_cislo,
                    jmeno,
                    prijmeni,
                    telefon
    FROM ZAMESTNANEC ZAMESTNANEC1
    NATURAL JOIN (
        SELECT DISTINCT id_zam
        FROM KONZULTANT KONZULTANT1
        NATURAL JOIN (
            SELECT DISTINCT id_objednavka,
                            id_zam,
                            id_zakaznik,
                            cena,
                            datum
            FROM OBJEDNAVKA OBJEDNAVKA1
            NATURAL JOIN (
                SELECT DISTINCT id_sluzba,
                                id_objednavka
                FROM SLUZBA_OBJEDNAVKA SLUZBA_OBJEDNAVKA1
                NATURAL JOIN (
                    SELECT DISTINCT id_sluzba,
                                    id_typ_sluzba
                    FROM SLUZBA SLUZBA1
                    NATURAL JOIN (
                        SELECT DISTINCT *
                        FROM TYP_SLUZBA TYP_SLUZBA1
                        WHERE popis = 'Fotografie a videa'
                    ) R7
                ) R8
            ) R9
        ) R10
    ) R11
) R12;
-- Najdi všechny exkurze, kde byla používána loď “Falcon”.
SELECT DISTINCT nazev
FROM (
    SELECT DISTINCT id_lod AS k1,
                    nazev
    FROM EXKURZE
) R1
JOIN (
    SELECT DISTINCT id_lod AS k2
    FROM LOD
    WHERE LOD.nazev = 'Falcon'
) R2 ON k1 = k2;
-- Všechny možné kombinace planet a lodi.
SELECT DISTINCT k1,
                k2
FROM (
    SELECT DISTINCT nazev AS k1
    FROM PLANETA
) R1
CROSS JOIN (
    SELECT DISTINCT nazev AS k2
    FROM LOD
) R2;
-- Pocet objednavek zpracovaných konzultanty.
select count(o.id_objednavka)
from objednavka o join (konzultant k join zamestnanec using(id_zam)) on o.id_zam=k.id_zam

-- Vyber lodi, ktere nemají žádnou exkurzí.
--left join
select l.nazev
from lod l
left join exkurze e on l.id_lod=e.id_lod
where e.id_lod is null;


--not in
select l.nazev
from lod l
where l.id_lod not in (select id_lod from exkurze);


--except
select lo.nazev
from lod lo
join (select l.id_lod from lod l
except
select e.id_lod from exkurze e)p on lo.id_lod=p.id_lod

-- Seznam zaměstnanců kteří vyřadili objednávku zákazníků se jménem ´Daniel´ a zaměstnanci, kteří bydlí mimo Moskvy .
SELECT DISTINCT jmeno
FROM (
    SELECT DISTINCT id_zam,
                    id_adresa,
                    osobni_cislo,
                    jmeno,
                    prijmeni,
                    telefon
    FROM ZAMESTNANEC
    NATURAL JOIN (
        SELECT DISTINCT id_objednavka,
                        id_zam,
                        id_zakaznik,
                        cena,
                        datum
        FROM OBJEDNAVKA
        NATURAL JOIN (
            SELECT DISTINCT *
            FROM ZAKAZNIK
            WHERE jmeno = 'Daniil'
        ) R1
    ) R2
) R3
UNION
SELECT DISTINCT jmeno
FROM (
    SELECT DISTINCT id_zam,
                    id_adresa,
                    osobni_cislo,
                    jmeno,
                    prijmeni,
                    telefon
    FROM ZAMESTNANEC ZAMESTNANEC1
    NATURAL JOIN (
        SELECT DISTINCT *
        FROM ADRESA
        WHERE mesto != 'Moscow'
    ) R4
) R5;

-- Kolik by bylo exkurzi , jestli by každá loď navštívila každou planetu?
select count(*) as Teoreticky_pocet from lod cross join planeta

-- Vypiš nejstarší objednávku(jméno,příjmení a datum) každého zákazníků.
select jmeno,(select min(datum) as nejstarsi from objednavka o where o.id_zakaznik = z.id_zakaznik) from zakaznik z

-- Objednávky, které vyřizoval konzultant s osobním číslem 100.
select * from objednavka  o join (konzultant k join zamestnanec z using(id_zam))  on o.id_zam=k.id_zam
where z.osobni_cislo='100'
-- Smaž zákazníci, kteří nic neobjednali.
begin;
select * from zakaznik;
select id_zakaznik from zakaznik where id_zakaznik not in(select id_zakaznik from objednavka);
delete from zakaznik where id_zakaznik in(select id_zakaznik from zakaznik where id_zakaznik not in(select id_zakaznik from objednavka));
select * from zakaznik;
rollback;
-- Do konzultanů přidej nových zaměstnanců, kteří nejsou konzultanty.
begin;
select * from konzultant join zamestnanec using (id_zam);
insert into konzultant(id_zam)
select id_zam from( 
select distinct id_zam from zamestnanec
) insert_one 
where id_zam not in (select id_zam from konzultant)
order by random() limit 1;
select * from konzultant join zamestnanec using (id_zam);
rollback;

-- Vytvoř pohled na bohaté zaměstnanci, kteří jsou konzultanty( znamená ,že vyřazují objednávky) a zároveň mají plat větší než 10000.
create view  bohate_zamestnanci  as
select * from zamestnanec z 
where plat >10000 and exists(select * from objednavka o where o.id_objednavka=z.id_zam);

select *  from bohate_zamestnanci;
drop view bohate_zamestnanci 

-- Nad pohledem bohate_zamestnanci udělej dotaz, plat vynásobte dvěma.
create view  bohate_zamestnanci  as
select * from zamestnanec z 
where plat >10000 and exists(select * from objednavka o where o.id_objednavka=z.id_zam);

select * from  bohate_zamestnanci;
update bohate_zamestnanci set plat=plat*2;
select * from  bohate_zamestnanci;
drop view bohate_zamestnanci;
rollback;

-- Vyber lodi a planety do kterých létaly ,včetně lodi, které nelétaly do žádnou
select distinct p.nazev as PLANETA,l.nazev as LOD
from lod l
full outer join exkurze e on l.id_lod=e.id_lod
left join planeta p on p.id_planeta=e.id_planeta

-- Vyber plat zaměstnanců, a kolik tento plat dostávají.
SELECT plat, COUNT(*) as count FROM zamestnanec GROUP BY plat

-- Najděte jména konzultantů, součet všech zpracovaných objednávek a počet objednávek, které zpracovali. Konzultant by měl vydělat více než 10 000 mít více než 1 objednávku. Seskupte podle jména.Výstup seřaďte podle počtu objednavek vzestupně
select z.jmeno,sum(cena), count (o.id_objednavka) as pocet_objednavek
from objednavka o join (konzultant k join zamestnanec z using(id_zam))  on o.id_zam=k.id_zam
where z.plat=10000
group by z.jmeno

having count(o.id_objednavka)>1
order by  pocet_objednavek asc

--Sniž plat o 1000 všem konzultantům, kteří vyřizovali objednávky zákazníků s jménem Vladimír.
begin;
select * from konzultant join zamestnanec using(id_zam);
select z.id_zam ,z.jmeno ,z.plat, z.telefon from  zamestnanec z join konzultant k using(id_zam) join objednavka o on o.id_zam=k.id_zam join zakaznik  za  on o.id_zakaznik=za.id_zakaznik where za.jmeno='Vladimir'; 


update zamestnanec 
set plat=plat-1000
where id_zam in(
select k.id_zam from konzultant k  join objednavka o on o.id_zam=k.id_zam join zakaznik  za  on o.id_zakaznik=za.id_zakaznik where za.jmeno='Vladimir' );
select * from konzultant join zamestnanec using(id_zam);
rollback
