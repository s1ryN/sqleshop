-- 7) UPDATE: Zvys cenu o 10% pro produkty se skladem < 10
UPDATE produkty p
JOIN sklad s ON p.produkt_id = s.produkt_id
SET p.cena = p.cena * 1.10
WHERE s.mnozstvi < 1000;

SELECT p.cena, p.nazev FROM sklad s
join produkty p ON s.produkt_id = p.produkt_id;  -- zobrazeni nove ceny produktu (zakladni ceny 22000, 18000, 30000)