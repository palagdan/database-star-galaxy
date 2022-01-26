-- odeberu pokud existuje funkce na oodebrání tabulek a sekvencí
DROP FUNCTION IF EXISTS remove_all();

-- vytvořím funkci která odebere tabulky a sekvence
CREATE or replace FUNCTION remove_all() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- zavolám funkci co odebere tabulky a sekvence - Mohl bych dropnout celé schéma a znovu jej vytvořit, použíjeme však PLSQL
select remove_all();


-- Remove conflicting tables
-- DROP TABLE IF EXISTS adresa CASCADE;
-- DROP TABLE IF EXISTS exkurze CASCADE;
-- DROP TABLE IF EXISTS konzultant CASCADE;
-- DROP TABLE IF EXISTS lod CASCADE;
-- DROP TABLE IF EXISTS objednavka CASCADE;
-- DROP TABLE IF EXISTS planeta CASCADE;
-- DROP TABLE IF EXISTS sluzba CASCADE;
-- DROP TABLE IF EXISTS soustava CASCADE;
-- DROP TABLE IF EXISTS stat CASCADE;
-- DROP TABLE IF EXISTS suvenyr CASCADE;
-- DROP TABLE IF EXISTS typ_sluzba CASCADE;
-- DROP TABLE IF EXISTS zakaznik CASCADE;
-- DROP TABLE IF EXISTS zamestnanec CASCADE;
-- DROP TABLE IF EXISTS sluzba_objednavka CASCADE;
-- End of removing

CREATE TABLE adresa (
    id_adresa SERIAL NOT NULL,
    id_stat INTEGER NOT NULL,
    mesto VARCHAR(60) NOT NULL,
    ulice VARCHAR(100) NOT NULL,
    cislo VARCHAR(40) NOT NULL,
    psc VARCHAR(30)
);
ALTER TABLE adresa ADD CONSTRAINT pk_adresa PRIMARY KEY (id_adresa);

CREATE TABLE exkurze (
    id_sluzba INTEGER NOT NULL,
    id_lod INTEGER NOT NULL,
    id_planeta INTEGER NOT NULL,
    nazev VARCHAR(100) NOT NULL,
    trvani VARCHAR(256) NOT NULL
);
ALTER TABLE exkurze ADD CONSTRAINT pk_exkurze PRIMARY KEY (id_sluzba);

CREATE TABLE konzultant (
    id_zam INTEGER NOT NULL
);
ALTER TABLE konzultant ADD CONSTRAINT pk_konzultant PRIMARY KEY (id_zam);

CREATE TABLE lod (
    id_lod SERIAL NOT NULL,
    kapacita VARCHAR(100) NOT NULL,
    nazev VARCHAR(60) NOT NULL,
    rychlost VARCHAR(256)
);
ALTER TABLE lod ADD CONSTRAINT pk_lod PRIMARY KEY (id_lod);

CREATE TABLE objednavka (
    id_objednavka SERIAL NOT NULL,
    id_zam INTEGER NOT NULL,
    id_zakaznik INTEGER NOT NULL,
    cena NUMERIC(20,2) NOT NULL,
    datum DATE NOT NULL
);
ALTER TABLE objednavka ADD CONSTRAINT pk_objednavka PRIMARY KEY (id_objednavka);

CREATE TABLE planeta (
    id_planeta SERIAL NOT NULL,
    id_soustava INTEGER NOT NULL,
    nazev VARCHAR(60) NOT NULL,
    vzdalenost VARCHAR(4000) NOT NULL
);
ALTER TABLE planeta ADD CONSTRAINT pk_planeta PRIMARY KEY (id_planeta);

CREATE TABLE sluzba (
    id_sluzba SERIAL NOT NULL,
    id_typ_sluzba INTEGER NOT NULL
);
ALTER TABLE sluzba ADD CONSTRAINT pk_sluzba PRIMARY KEY (id_sluzba);

CREATE TABLE soustava (
    id_soustava SERIAL NOT NULL,
    nazev VARCHAR(60) NOT NULL,
    vzdalenost VARCHAR(4000) NOT NULL
);
ALTER TABLE soustava ADD CONSTRAINT pk_soustava PRIMARY KEY (id_soustava);

CREATE TABLE stat (
    id_stat SERIAL NOT NULL,
    nazev_stat VARCHAR(40) NOT NULL
);
ALTER TABLE stat ADD CONSTRAINT pk_stat PRIMARY KEY (id_stat);

CREATE TABLE suvenyr (
    id_sluzba INTEGER NOT NULL,
    cena Numeric(30,0) NOT NULL,
    nazev VARCHAR(100) NOT NULL
);
ALTER TABLE suvenyr ADD CONSTRAINT pk_suvenyr PRIMARY KEY (id_sluzba);

CREATE TABLE typ_sluzba (
    id_typ_sluzba SERIAL NOT NULL,
    popis VARCHAR(3000) NOT NULL
);
ALTER TABLE typ_sluzba ADD CONSTRAINT pk_typ_sluzba PRIMARY KEY (id_typ_sluzba);

CREATE TABLE zakaznik (
    id_zakaznik SERIAL NOT NULL,
    id_adresa INTEGER NOT NULL,
    jmeno VARCHAR(30) NOT NULL,
    prijmeni VARCHAR(60) NOT NULL,
    telefon VARCHAR(100) NOT NULL
);
ALTER TABLE zakaznik ADD CONSTRAINT pk_zakaznik PRIMARY KEY (id_zakaznik);

CREATE TABLE zamestnanec (
    id_zam SERIAL NOT NULL,
    id_adresa INTEGER NOT NULL,
    osobni_cislo VARCHAR(30) NOT NULL,
    jmeno VARCHAR(30) NOT NULL,
    prijmeni VARCHAR(60) NOT NULL,
    telefon VARCHAR(100) NOT NULL,
    plat numeric(10,0)
);
ALTER TABLE zamestnanec ADD CONSTRAINT ch_plat check(zamestnanec.plat>1000);


ALTER TABLE zamestnanec ADD CONSTRAINT pk_zamestnanec PRIMARY KEY (id_zam);
ALTER TABLE zamestnanec ADD CONSTRAINT uc_zamestnanec_osobni_cislo UNIQUE (osobni_cislo);

CREATE TABLE sluzba_objednavka (
    id_sluzba INTEGER NOT NULL,
    id_objednavka INTEGER NOT NULL
);
ALTER TABLE sluzba_objednavka ADD CONSTRAINT pk_sluzba_objednavka PRIMARY KEY (id_sluzba, id_objednavka);

ALTER TABLE adresa ADD CONSTRAINT fk_adresa_stat FOREIGN KEY (id_stat) REFERENCES stat (id_stat) ON DELETE CASCADE;

ALTER TABLE exkurze ADD CONSTRAINT fk_exkurze_sluzba FOREIGN KEY (id_sluzba) REFERENCES sluzba (id_sluzba) ON DELETE CASCADE;
ALTER TABLE exkurze ADD CONSTRAINT fk_exkurze_lod FOREIGN KEY (id_lod) REFERENCES lod (id_lod) ON DELETE CASCADE;
ALTER TABLE exkurze ADD CONSTRAINT fk_exkurze_planeta FOREIGN KEY (id_planeta) REFERENCES planeta (id_planeta) ON DELETE CASCADE;

ALTER TABLE konzultant ADD CONSTRAINT fk_konzultant_zamestnanec FOREIGN KEY (id_zam) REFERENCES zamestnanec (id_zam) ON DELETE CASCADE;

ALTER TABLE objednavka ADD CONSTRAINT fk_objednavka_konzultant FOREIGN KEY (id_zam) REFERENCES konzultant (id_zam) ON DELETE CASCADE;
ALTER TABLE objednavka ADD CONSTRAINT fk_objednavka_zakaznik FOREIGN KEY (id_zakaznik) REFERENCES zakaznik (id_zakaznik) ON DELETE CASCADE;

ALTER TABLE planeta ADD CONSTRAINT fk_planeta_soustava FOREIGN KEY (id_soustava) REFERENCES soustava (id_soustava) ON DELETE CASCADE;

ALTER TABLE sluzba ADD CONSTRAINT fk_sluzba_typ_sluzba FOREIGN KEY (id_typ_sluzba) REFERENCES typ_sluzba (id_typ_sluzba) ON DELETE CASCADE;

ALTER TABLE suvenyr ADD CONSTRAINT fk_suvenyr_sluzba FOREIGN KEY (id_sluzba) REFERENCES sluzba (id_sluzba) ON DELETE CASCADE;

ALTER TABLE zakaznik ADD CONSTRAINT fk_zakaznik_adresa FOREIGN KEY (id_adresa) REFERENCES adresa (id_adresa) ON DELETE CASCADE;

ALTER TABLE zamestnanec ADD CONSTRAINT fk_zamestnanec_adresa FOREIGN KEY (id_adresa) REFERENCES adresa (id_adresa) ON DELETE CASCADE;

ALTER TABLE sluzba_objednavka ADD CONSTRAINT fk_sluzba_objednavka_sluzba FOREIGN KEY (id_sluzba) REFERENCES sluzba (id_sluzba) ON DELETE CASCADE;
ALTER TABLE sluzba_objednavka ADD CONSTRAINT fk_sluzba_objednavka_objednavka FOREIGN KEY (id_objednavka) REFERENCES objednavka (id_objednavka) ON DELETE CASCADE;

