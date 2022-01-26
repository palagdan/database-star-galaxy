-- smazání všech záznamů z tabulek

CREATE or replace FUNCTION clean_tables() RETURNS void AS $$
declare
  l_stmt text;
begin
  select 'truncate ' || string_agg(format('%I.%I', schemaname, tablename) , ',')
    into l_stmt
  from pg_tables
  where schemaname in ('public');

  execute l_stmt || ' cascade';
end;
$$ LANGUAGE plpgsql;
select clean_tables();

-- reset sekvenci

CREATE or replace FUNCTION restart_sequences() RETURNS void AS $$
DECLARE
i TEXT;
BEGIN
 FOR i IN (SELECT column_default FROM information_schema.columns WHERE column_default SIMILAR TO 'nextval%')
  LOOP
         EXECUTE 'ALTER SEQUENCE'||' ' || substring(substring(i from '''[a-z_]*')from '[a-z_]+') || ' '||' RESTART 1;';
  END LOOP;
END $$ LANGUAGE plpgsql;
select restart_sequences();
-- konec resetu



--plnění stat
insert into stat (nazev_stat) values ('Russia');
insert into stat (nazev_stat) values ('Czech Republic');
insert into stat (nazev_stat) values ('Poland');
insert into stat (nazev_stat) values ('Slovakia');
insert into stat (nazev_stat) values ('USA');
insert into stat (nazev_stat) values ('Ukraine');
insert into stat (nazev_stat) values ('England');

--plneni adresa
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (2, 'Prague' ,'6', 'Bartillon Circle', '9037');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (2, 'Hostavice', '1', 'Muir Parkway', '198 00');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Xinheng', '2327', 'Sachtjen Terrace', null);
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Sumber Tengah', '3', 'Marcy Lane', null);
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (5, 'Thị Trấn Tủa Chùa', '61', 'Brentwood Lane', null);
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (6, 'San Jose', '9','Vahlen Trail', '69570');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (7, 'Bystra', '720', 'Stuart Park', '34-382');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (5, 'Anggana', '51', 'Katie Drive', null);
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (2, 'Prague', '57', 'Eastlawn Road', '13867 CEDEX 9');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Pyatovskiy', '357', 'Everett Place', '249903');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (2, 'Moscow', '98784', 'Redwing Street', '72-510');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (2, 'Jaša Tomić', '05843', 'Bay Court', null);
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Zamoskvorech’ye', '7495', 'Michigan Road', '142817');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (3, 'Selaawi', '519', 'Goodland Alley', null);
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (6, 'Santana do Ipanema', '72830', 'Swallow Avenue', '57500-000');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (2, 'Prague', '72830', 'Strachov', '34500-000');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Anapa', '72830', 'Lenina', '23340000');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Krasnodar', '72830', 'Lenina', '3445500');
insert into adresa (id_stat, mesto, cislo, ulice, psc) values (1, 'Moscow', '72830', 'Vasechenko', '53234553');
--plneni zakaznik
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (1, 1, 'Daniil', 'Palagin', '538-719-8660');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (2, 2, 'Alana Kaytukova', 'Culpin', '927-202-0014');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (3, 3, 'Danila', 'Malukov', '994-441-1629');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (4, 4, 'Rachèle', 'Wadeling', '444-608-3249');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (5, 5, 'Garçon', 'Purcer', '612-494-3113');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (6, 6, 'Zhì', 'Bertie', '378-369-8858');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (7, 7, 'Örjan', 'Klarzynski', '573-203-2464');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (8, 8, 'Vladimir', 'Beamand', '161-221-5532');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (9, 16, 'Marta', 'Bad', '344-223-324');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (10, 17, 'Raydon', 'Grin', '345-554-335');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (11, 18, 'Remor', 'Beamand', '122-123-432');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (12, 19, 'Nalop', 'Star', '161-221-567');
insert into zakaznik (id_zakaznik, id_adresa, jmeno, prijmeni, telefon) values (13, 19, 'Repo', 'Sero', '123-221-567');



--plneni zamestnanec

insert into zamestnanec (osobni_cislo, id_adresa, jmeno, prijmeni, telefon,plat) values (100, 9, 'Annotés', 'Knight', '425-888-4031',10000);
insert into zamestnanec (osobni_cislo, id_adresa,  jmeno, prijmeni, telefon,plat) values (101, 10, 'Maéna', 'Robardley', '980-190-5097',10000);
insert into zamestnanec (osobni_cislo, id_adresa, jmeno, prijmeni, telefon,plat) values (102, 11, 'Valérie', 'OBruen', '568-535-7143',11000);
insert into zamestnanec (osobni_cislo, id_adresa, jmeno, prijmeni, telefon,plat) values (103, 12, 'Jakub', 'Novák', '473-905-4064',11000);
insert into zamestnanec (osobni_cislo, id_adresa, jmeno, prijmeni, telefon,plat) values (104, 13,  'Léonie', 'MacGrath', '495-161-1479',9000);
insert into zamestnanec (osobni_cislo, id_adresa, jmeno, prijmeni, telefon,plat) values (105, 14, 'Gaëlle', 'Pirson', '968-161-8210',3000);
insert into zamestnanec (osobni_cislo, id_adresa, jmeno, prijmeni, telefon,plat) values (106, 15, 'Léandre', 'Horney', '591-517-3780',3000);

--plneni konzultant
insert into konzultant (id_zam) values (1);
insert into konzultant(id_zam) values (2);
insert into konzultant (id_zam) values (3);
insert into konzultant(id_zam) values (4);

--plneni typ_sluzba
insert into Typ_sluzba(id_typ_sluzba,popis) values (1 ,'Exkurze');
insert into Typ_sluzba (id_typ_sluzba,popis) values (2, 'Suvenyr');
insert into Typ_sluzba (id_typ_sluzba,popis) values (3, 'Fotografie a videa');



--plneni objednavka
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(1,1,1,3450000,to_date('19-03-2018', 'dd-mm-yyyy'));
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(2,1,2 , 345000, to_date('13-04-2019', 'dd-mm-yyyy'));
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(3,1, 3, 345000,to_date('12-03-2017', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(4,3, 11,345000 ,to_date('15-03-2020', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(5,3, 4, 345000,to_date('1-05-2023', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(6,4, 5, 2345,to_date('20-04-2018', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(7,3, 6, 2322567,to_date('20-04-2018', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(8,2, 7, 12213353,to_date('20-04-2018', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(9,1, 8, 12345677,to_date('20-04-2019', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(10,3, 9, 1234566,to_date('20-04-2020', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(11,4, 10, 13468787,to_date('20-04-2021', 'dd-mm-yyyy') );
insert into objednavka(id_objednavka,id_zam,id_zakaznik,cena,datum) values(12,2, 12, 13468787,to_date('20-04-2021', 'dd-mm-yyyy') );

--plneni sluzba
insert into sluzba(id_sluzba,id_typ_sluzba) values(1,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(2,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(3,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(4,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(5,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(6,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(7,2);
insert into sluzba(id_sluzba,id_typ_sluzba) values(8,2);
insert into sluzba(id_sluzba,id_typ_sluzba) values(9,2);
insert into sluzba(id_sluzba,id_typ_sluzba) values(10,2);
insert into sluzba(id_sluzba,id_typ_sluzba) values(11,2);
insert into sluzba(id_sluzba,id_typ_sluzba) values(12,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(13,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(14,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(15,1);
insert into sluzba(id_sluzba,id_typ_sluzba) values(16,3);

--plneni sluzba_objednavka
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(1,1);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(2,2);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(3,3);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(4,4);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(5,5);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(6,6);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(7,7);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(8,8);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(9,9);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(10,10);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(11,11);
insert into sluzba_objednavka(id_sluzba,id_objednavka) values(16,12);


--plnění soustava
insert into soustava (nazev,vzdalenost) values ('Solar' , '0');
insert into soustava (nazev,vzdalenost) values ('Gliese 876', '345000000');
insert into soustava (nazev,vzdalenost) values ('Gliese 876', '34575555555556');
insert into soustava (nazev,vzdalenost) values ('Gliese 676', '4557000000000');
insert into soustava (nazev,vzdalenost) values ('Proxima Centauri b', '345632222222');
insert into soustava (nazev,vzdalenost) values ('Kepler-446' , '344567788888888');
insert into soustava (nazev,vzdalenost) values ('Sirius' , '344567788856888');
insert into soustava (nazev,vzdalenost) values ('Polaris' , '34456778885688856576768889');


--plneni Planeta
insert into planeta(id_soustava, nazev,vzdalenost) values(1, 'Mars','234000000');
insert into planeta(id_soustava, nazev,vzdalenost) values(1, 'Jupiter','234000000');
insert into planeta(id_soustava, nazev,vzdalenost) values(3, 'Gliese 832c','234000000');
insert into planeta(id_soustava, nazev,vzdalenost) values(4, 'Gliese 581c','234000000');
insert into planeta(id_soustava, nazev,vzdalenost) values(5, 'Gliese581 d','234000000');
insert into planeta(id_soustava, nazev,vzdalenost) values(8, 'Thanagar','34456778885688856576768885');
insert into planeta(id_soustava, nazev,vzdalenost) values(8, 'Rahn','34456778885688856576768456');


--plneni lod
insert into lod(kapacita,nazev,rychlost) values('150', 'Falcon', '23400000');
insert into lod(kapacita,nazev,rychlost) values('200', 'Sputnik', '343400000');
insert into lod(kapacita,nazev,rychlost) values('100', 'Soyuz', '22400000');
insert into lod(kapacita,nazev,rychlost) values('100', 'Soyka', '33400000');
insert into lod(kapacita,nazev,rychlost) values('120', 'Sunset', '330000');
insert into lod(kapacita,nazev,rychlost) values('140', 'Orto', '335000');

--plneni exkurze
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(1,1,1, 'Hroza', '345');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(2,2,1, 'Malcon', '345');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(3,3,1, 'Kcew', '34365');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(4,7, 3,'Razboi', '344422');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(5,3,4, 'Dragon', '557883');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(6,3,2, 'Malcon1', '345456');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(12,4,1, 'Malcon2', '345456');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(13,5,1, 'Cz', '345456');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(14,6,1, 'Dragon2', '345456');
Insert into exkurze(id_sluzba,id_planeta,id_lod,nazev,trvani) values(15,7,1, 'Cwark', '345456');



--plneni suvenyru
insert into suvenyr(id_sluzba,cena,nazev) values(7,3000,'Retort');
insert into suvenyr(id_sluzba,cena,nazev) values(8,35000,'Tranorus');
insert into suvenyr(id_sluzba,cena,nazev) values(9,23003,'Drabl');
insert into suvenyr(id_sluzba,cena,nazev) values(10,123400,'Kira');
insert into suvenyr(id_sluzba,cena,nazev) values(11,345332,'Krolan');



