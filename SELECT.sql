-- Ukazkove SELECT dotazy
-- 1) Vyber vsechny produkty v kategorii Elektronika (LIKE)
SELECT p.nazev, p.cena, k.nazev, pk.produkt_id
FROM produkty p
JOIN produkt_kategorie pk ON p.produkt_id = pk.produkt_id -- JOIN spoji tabulky, zde nastavena reference pro SELECT k.nazev a pk.id
JOIN kategorie k ON pk.kategorie_id = k.kategorie_id
WHERE k.nazev LIKE 'Mobi%' /*Mobily*/ OR k.nazev LIKE '%Booky'; -- Notebooky

-- 2) Pocet objednavek a celkova trzni castka podle uzivatele
SELECT u.jmeno, u.prijmeni,
       COUNT(o.objednavka_id) AS pocet_obj,
       SUM(o.celkova_castka) AS trzni_prijem
FROM uzivatele u
LEFT JOIN objednavky o ON u.uzivatel_id = o.uzivatel_id
GROUP BY u.uzivatel_id -- Spojeni do skupin podle id uzivatele
ORDER BY trzni_prijem DESC; -- DESC je pro nejvyssi do nejnizsi

-- 3) Prumerna cena vsech produktu
SELECT AVG(cena) AS prumerna_cena FROM produkty; -- Agregacni fce AVG

-- 4) Top 5 nejprodavanejsich produktu
SELECT p.nazev, SUM(po.mnozstvi) AS prodane_kusy -- Agregacni fce SUM pro soucet
FROM produkty p -- Oznaceni tabulky produkty alternativním nazvem "p"
JOIN polozky_objednavky po ON p.produkt_id = po.produkt_id
GROUP BY p.produkt_id
ORDER BY prodane_kusy DESC -- DESC je pro nejvyssi do nejnizsi
LIMIT 5; -- Limitace vypisu

-- 5) Najdi uzivatele, kde prijmeni zaciná na 'Novak'
SELECT * FROM uzivatele WHERE prijmeni LIKE 'Novak%'; -- Najde vsechny s prijmenim Novak nebo Novakova

-- 6) Objednavky z oblasti Praha
SELECT o.objednavka_id, a.mesto, o.celkova_castka
FROM objednavky o
JOIN adresy a ON o.adresa_doruceni_id = a.adresa_id
WHERE a.oblast = 'Praha'; -- WHERE urcuje odkud pochazi
