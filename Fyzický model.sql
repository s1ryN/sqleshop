-- ESHOP DATABAZE SCHEMA (zjednodusene, czech names)
-- MySQL compatible

CREATE DATABASE eshop;
USE eshop;
-- Lookup tabulka pro typ adresy
CREATE TABLE typ_adresy (
    typ_id      INT AUTO_INCREMENT PRIMARY KEY,      -- PK: identifikator typu
    kod         VARCHAR(50) NOT NULL UNIQUE,       -- kod typu (e.g. 'billing','shipping')
    popis       VARCHAR(100)                     -- popis typu adresy
);

-- Lookup tabulka pro stav objednavky
CREATE TABLE stav_objednavky (
    stav_id     INT AUTO_INCREMENT PRIMARY KEY,
    kod         VARCHAR(50) NOT NULL UNIQUE,      -- kod stavu
    popis       VARCHAR(100)
);

-- Lookup tabulka pro metodu platby
CREATE TABLE metoda_platby (
    metoda_id   INT AUTO_INCREMENT PRIMARY KEY,
    kod         VARCHAR(50) NOT NULL UNIQUE,      -- kod metody (e.g. 'credit_card','paypal',...)
    popis       VARCHAR(100)
);

-- Lookup tabulka pro stav platby
CREATE TABLE stav_platby (
    stav_id     INT AUTO_INCREMENT PRIMARY KEY,
    kod         VARCHAR(50) NOT NULL UNIQUE,
    popis       VARCHAR(100)
);

-- Lookup tabulka pro stav zasilky
CREATE TABLE stav_zasilky (
    stav_id     INT AUTO_INCREMENT PRIMARY KEY,
    kod         VARCHAR(50) NOT NULL UNIQUE,
    popis       VARCHAR(100)
);

-- Lookup tabulka pro typ slevy
CREATE TABLE typ_slevy (
    typ_id      INT AUTO_INCREMENT PRIMARY KEY,
    kod         VARCHAR(50) NOT NULL UNIQUE,      -- 'fixed','percent'
    popis       VARCHAR(100)
);

-- Tabulka uzivatelu (zakaznici)
CREATE TABLE uzivatele (
    uzivatel_id        INT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikace uzivatele
    email              VARCHAR(255) NOT NULL UNIQUE,   -- emailova adresa
    heslo_hash         VARCHAR(255) NOT NULL,          -- zahashovane heslo
    jmeno              VARCHAR(100) NOT NULL,          -- krestni jmeno
    prijmeni           VARCHAR(100) NOT NULL,          -- prijmeni
    telefon            VARCHAR(20),                    -- telefonni cislo
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP, -- datum a cas vytvoreni
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- datum a cas posledni zmeny
);

-- Tabulka adres uzivatelu
CREATE TABLE adresy (
    adresa_id          INT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikace adresy
    uzivatel_id        INT NOT NULL,                    -- FK: uzivatel
    typ_id             INT NOT NULL,                    -- FK: typ adresy
    ulice              VARCHAR(255) NOT NULL,           -- ulice a cislo
    mesto              VARCHAR(100) NOT NULL,           -- mesto
    oblast             VARCHAR(100),                    -- region / kraj
    psc                VARCHAR(20) NOT NULL,            -- postalni smerovaci cislo
    stat               VARCHAR(100) NOT NULL,           -- stat
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP, -- datum vytvoreni
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- datum upravy
    FOREIGN KEY (uzivatel_id) REFERENCES uzivatele(uzivatel_id),
    FOREIGN KEY (typ_id) REFERENCES typ_adresy(typ_id)
);

-- Tabulka kategorii (hierarchie)
CREATE TABLE kategorie (
    kategorie_id       INT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikace kategorie
    nazev              VARCHAR(100) NOT NULL,          -- nazev kategorie
    popis              TEXT,                           -- popis kategorie
    nadrazena_id       INT,                            -- FK: nadrazena kategorie
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP,
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (nadrazena_id) REFERENCES kategorie(kategorie_id)
);

-- Tabulka produktu
CREATE TABLE produkty (
    produkt_id         INT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikace produktu
    nazev              VARCHAR(255) NOT NULL,          -- nazev produktu
    popis              TEXT,                           -- popis produktu
    sku                VARCHAR(100) NOT NULL UNIQUE,   -- skladove cislo
    cena               DECIMAL(10,2) NOT NULL,         -- prodejni cena
    nakupni_cena       DECIMAL(10,2),                  -- nakupni/vyrobni cena
    obrazek_url        VARCHAR(255),                   -- URL obrazku
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP,
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Spojovaci tabulka produkt-kategorie (M:N)
CREATE TABLE produkt_kategorie (
    produkt_id         INT NOT NULL,                   -- FK: produkt
    kategorie_id       INT NOT NULL,                   -- FK: kategorie
    PRIMARY KEY (produkt_id, kategorie_id),
    FOREIGN KEY (produkt_id) REFERENCES produkty(produkt_id),
    FOREIGN KEY (kategorie_id) REFERENCES kategorie(kategorie_id)
);

-- Tabulka skladu (inventory)
CREATE TABLE sklad (
    produkt_id         INT PRIMARY KEY,                -- FK: produkt
    mnozstvi           INT DEFAULT 0,                  -- pocet skladem
    rezervace          INT DEFAULT 0,                  -- pocet rezervovanych
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (produkt_id) REFERENCES produkty(produkt_id)
);

-- Tabulka objednavky
CREATE TABLE objednavky (
    objednavka_id      BIGINT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikace objednavky
    uzivatel_id        INT NOT NULL,                    -- FK: uzivatel
    datum_objednavky   DATETIME DEFAULT CURRENT_TIMESTAMP, -- datum objednani
    stav_id            INT NOT NULL,                    -- FK: stav objednavky
    adresa_doruceni_id INT NOT NULL,                    -- FK: dorucovaci adresa
    adresa_fakturace_id INT NOT NULL,                   -- FK: fakturacni adresa
    celkova_castka     DECIMAL(12,2) NOT NULL,         -- celkova castka
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP,
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (uzivatel_id) REFERENCES uzivatele(uzivatel_id),
    FOREIGN KEY (stav_id) REFERENCES stav_objednavky(stav_id),
    FOREIGN KEY (adresa_doruceni_id) REFERENCES adresy(adresa_id),
    FOREIGN KEY (adresa_fakturace_id) REFERENCES adresy(adresa_id)
);

-- Tabulka polozky_objednavky
CREATE TABLE polozky_objednavky (
    polozka_id         BIGINT AUTO_INCREMENT PRIMARY KEY, -- PK: identifikace polozky objednavky
    objednavka_id      BIGINT NOT NULL,                 -- FK: objednavka
    produkt_id         INT NOT NULL,                    -- FK: produkt
    mnozstvi           INT NOT NULL,                    -- mnozstvi produktu
    cena_za_jednotku   DECIMAL(10,2) NOT NULL,          -- cena za kus
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (objednavka_id) REFERENCES objednavky(objednavka_id),
    FOREIGN KEY (produkt_id) REFERENCES produkty(produkt_id)
);

-- Tabulka platby
CREATE TABLE platby (
    platba_id          BIGINT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikator platby
    objednavka_id      BIGINT NOT NULL,                 -- FK: objednavka
    datum_platby       DATETIME DEFAULT CURRENT_TIMESTAMP, -- datum platby
    castka             DECIMAL(12,2) NOT NULL,          -- zaplacena castka
    metoda_id          INT NOT NULL,                    -- FK: metoda platby
    stav_id            INT NOT NULL,                    -- FK: stav platby
    transakce_id       VARCHAR(255),                    -- externi ID transakce
    FOREIGN KEY (objednavka_id) REFERENCES objednavky(objednavka_id),
    FOREIGN KEY (metoda_id) REFERENCES metoda_platby(metoda_id),
    FOREIGN KEY (stav_id) REFERENCES stav_platby(stav_id)
);

-- Tabulka zasilky
CREATE TABLE zasilky (
    zasilka_id         BIGINT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikator zasilky
    objednavka_id      BIGINT NOT NULL,                 -- FK: objednavka
    datum_odeslani     DATETIME,                        -- datum odeslani
    predpokladane_doruceni DATETIME,                   -- ETA
    datum_doruceni     DATETIME,                        -- datum doruceni
    dopravce           VARCHAR(100),                    -- nazev dopravce
    cislo_zasilky      VARCHAR(100),                    -- cislo zasilky
    stav_id            INT NOT NULL,                    -- FK: stav zasilky
    FOREIGN KEY (objednavka_id) REFERENCES objednavky(objednavka_id),
    FOREIGN KEY (stav_id) REFERENCES stav_zasilky(stav_id)
);

-- Tabulka recenze
CREATE TABLE recenze (
    recenze_id         BIGINT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikator recenze
    produkt_id         INT NOT NULL,                    -- FK: produkt
    uzivatel_id        INT NOT NULL,                    -- FK: uzivatel
    hodnoceni          TINYINT NOT NULL CHECK (hodnoceni BETWEEN 1 AND 5), -- hodnoceni 1-5
    nadpis             VARCHAR(255),                   -- nadpis recenze
    komentar           TEXT,                           -- text recenze
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP,
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (produkt_id) REFERENCES produkty(produkt_id),
    FOREIGN KEY (uzivatel_id) REFERENCES uzivatele(uzivatel_id)
);

-- Tabulka kupony
CREATE TABLE kupony (
    kupon_id           INT AUTO_INCREMENT PRIMARY KEY,  -- PK: identifikator kuponu
    kod                VARCHAR(50) NOT NULL UNIQUE,    -- kod kuponu
    typ_id             INT NOT NULL,                    -- FK: typ slevy
    hodnota_slevy      DECIMAL(10,2) NOT NULL,          -- hodnota slevy
    datum_zacatek      DATE,                            -- platnost od
    datum_konec        DATE,                            -- platnost do
    limit_vyuziti      INT,                             -- maximalni pocet vyuziti
    vytvoreno          DATETIME DEFAULT CURRENT_TIMESTAMP,
    upraveno           DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (typ_id) REFERENCES typ_slevy(typ_id)
);

-- Spojovaci tabulka objednavka-kupon
CREATE TABLE objednavka_kupon (
    objednavka_id      BIGINT NOT NULL,                 -- FK: objednavka
    kupon_id           INT NOT NULL,                    -- FK: kupon
    PRIMARY KEY (objednavka_id, kupon_id),
    FOREIGN KEY (objednavka_id) REFERENCES objednavky(objednavka_id),
    FOREIGN KEY (kupon_id) REFERENCES kupony(kupon_id)
);


