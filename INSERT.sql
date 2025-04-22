-- Prikladove INSERTS
-- lookup tabulky
USE eshop;
INSERT INTO typ_adresy (kod,popis) VALUES
  ('billing','fakturacni adresa'),
  ('shipping','dorucovaci adresa');

INSERT INTO stav_objednavky (kod,popis) VALUES
  ('pending','cekajici'),
  ('paid','zaplaceno'),
  ('processing','zpracovava se'),
  ('shipped','odeslano'),
  ('delivered','doručeno'),
  ('cancelled','zruseno'),
  ('returned','vraceno');

INSERT INTO metoda_platby (kod,popis) VALUES
  ('credit_card','platebni kartou'),
  ('paypal','PayPal'),
  ('bank_transfer','prevod na ucet'),
  ('cod','dobirka');

INSERT INTO stav_platby (kod,popis) VALUES
  ('pending','cekajici'),
  ('completed','dokonceno'),
  ('failed','neuspesna'),
  ('refunded','vraceno');

INSERT INTO stav_zasilky (kod,popis) VALUES
  ('pending','cekajici'),
  ('shipped','odeslano'),
  ('in_transit','na ceste'),
  ('delivered','doručeno'),
  ('returned','vraceno'),
  ('cancelled','zruseno');

INSERT INTO typ_slevy (kod,popis) VALUES
  ('fixed','pevna sleva'),
  ('percent','procentualni sleva');

-- uzivatele a adresy
INSERT INTO uzivatele (email,heslo_hash,jmeno,prijmeni,telefon) VALUES
  ('jan.novak@example.cz','hash1','Jan','Novak','608123456'),
  ('petra.svobodova@example.cz','hash2','Petra','Svobodova','602654321');

INSERT INTO adresy (uzivatel_id,typ_id,ulice,mesto,oblast,psc,stat) VALUES
  (1,2,'Hlavni 1','Praha','Praha','11000','Czechia'),
  (1,1,'Fakturacni 2','Praha','Praha','11000','Czechia'),
  (2,2,'Kvetna 5','Brno','Jihomoravsky','60200','Czechia'),
  (2,1,'Fakturacni 7','Brno','Jihomoravsky','60200','Czechia');

-- kategorie a produkty
INSERT INTO kategorie (nazev,popis,nadrazena_id) VALUES
  ('Elektronika','Elektronicke zarizeni',NULL),
  ('Mobily','Mobilni telefony',1),
  ('Notebooky','Prenosne pocitace',1);

INSERT INTO produkty (nazev,popis,sku,cena,nakupni_cena) VALUES
  ('iPhone 13','Smartphone Apple','IP13',22000,15000),
  ('Samsung Galaxy S21','Smartphone Samsung','SGS21',18000,12000),
  ('Dell XPS 13','Notebook Dell','DX13',30000,22000);

INSERT INTO produkt_kategorie (produkt_id,kategorie_id) VALUES
  (1,2),(2,2),(3,3);

INSERT INTO sklad (produkt_id,mnozstvi,rezervace) VALUES
  (1,50,5),(2,30,2),(3,15,0);

-- kupony
INSERT INTO kupony (kod,typ_id,hodnota_slevy,datum_zacatek,datum_konec,limit_vyuziti) VALUES
  ('WELCOME10',2,10,'2025-01-01','2025-12-31',100),
  ('VIP50',1,500,'2025-04-01','2025-06-30',50);

-- objednavky, polozky, platby, zasilky, objednavka-kupon
INSERT INTO objednavky (uzivatel_id,stav_id,adresa_doruceni_id,adresa_fakturace_id,celkova_castka) VALUES
  (1,2,1,2,22000),(2,1,3,4,18000);

INSERT INTO polozky_objednavky (objednavka_id,produkt_id,mnozstvi,cena_za_jednotku) VALUES
  (1,1,1,22000),(2,2,1,18000);

INSERT INTO platby (objednavka_id,castka,metoda_id,stav_id,transakce_id) VALUES
  (1,22000,1,2,'TX123'),(2,18000,4,1,NULL);

INSERT INTO zasilky (objednavka_id,datum_odeslani,predpokladane_doruceni,dopravce,cislo_zasilky,stav_id) VALUES
  (1,'2025-04-20','2025-04-25','Ceska posta','CP123456',2);

INSERT INTO objednavka_kupon (objednavka_id,kupon_id) VALUES
  (1,1);

INSERT INTO recenze (produkt_id,uzivatel_id,hodnoceni,nadpis,komentar) VALUES
  (1,1,5,'Vyborna kvalita','Skvely telefon, doporucuji'),
  (2,2,4,'Dobry, ale drahy','Funguje OK, cena je vysoka');

-- Konec prikladnych dotazu