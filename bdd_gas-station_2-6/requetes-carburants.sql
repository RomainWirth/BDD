
-- 1. Stations services qui possèdent le service 'vente de gaz domestique'
-- @block
SELECT * FROM point_de_vente AS pdv
JOIN service_point_de_vente AS spdv ON pdv.id = spdv.point_de_vente_id
JOIN service AS s ON spdv.service_id = s.id
WHERE s.nom = 'Vente de gaz domestique';

-- 1.a
-- @block
SELECT code_postal FROM point_de_vente AS pdv
JOIN service_point_de_vente AS spdv ON pdv.id = spdv.point_de_vente_id
JOIN service AS s ON spdv.service_id = s.id
WHERE s.nom = 'Vente de gaz domestique';

-- 1.b
-- @block
SELECT DISTINCT code_postal FROM point_de_vente AS pdv
JOIN service_point_de_vente AS spdv ON pdv.id = spdv.point_de_vente_id
JOIN service AS s ON spdv.service_id = s.id
WHERE s.nom = 'Vente de gaz domestique';

-- 2. Sélectionner le nombre de stations se trouvant à Annecy
-- @block
SELECT *
FROM point_de_vente
WHERE ville = 'ANNECY';

-- 2.a
-- @block
SELECT *
FROM point_de_vente
WHERE ville = 'ANNECY'
  AND automate_24_24 = True;

-- 3. Récupérer le nombre total de stations en France
-- @block
SELECT COUNT(*)
FROM point_de_vente;

-- 3.a
-- @block
SELECT COUNT(*)
FROM point_de_vente
WHERE code_postal LIKE '29%'
   OR code_postal LIKE '23%'
   OR code_postal LIKE '69%';

-- 4. Calculer la moyenne des prix du Gazole en France
-- 4.a
-- @block
SELECT AVG(valeur) AS moyenne_prix_gasole FROM prix, carburant AS c
WHERE c.id = prix.carburant_id
  AND c.nom = 'Gazole'
  AND prix.date::TEXT LIKE '2007%';

-- 4.b
-- @block
SELECT AVG(valeur) FROM prix, carburant AS c
WHERE c.id = prix.carburant_id
  AND c.nom = 'Gazole'
  AND prix.date::TEXT LIKE '2014%';

-- 4.c
-- @block
SELECT AVG(valeur)
FROM prix, carburant AS c
WHERE c.id = prix.carburant_id
  AND c.nom = 'Gazole'
  AND prix.date::TEXT LIKE '2023%';

-- @block
SELECT AVG(valeur)
FROM prix AS p
JOIN carburant AS c
    ON p.carburant_id = c.id
    AND c.nom = 'Gazole'
    AND p.date::TEXT LIKE '2023%';

-- 5. Calculer la moyenne des prix du Gazole par département et trier par département croissant
-- @block
SELECT LEFT(code_postal, 2) AS département, AVG(valeur) AS prix_moyen_gazole
FROM prix AS p, point_de_vente AS pdv, carburant AS c
    WHERE pdv.id = p.point_de_vente_id
    AND c.id = p.carburant_id
    AND c.nom = 'Gazole'
    GROUP BY département
    ORDER BY département ASC;

-- 5.a
-- @block
SELECT LEFT(pdv.code_postal, 2) AS département, AVG(valeur) AS avg_diesel
FROM point_de_vente AS pdv
JOIN prix AS p ON pdv.id = p.point_de_vente_id
JOIN carburant AS c ON p.carburant_id = c.id
WHERE c.nom = 'Gazole'
GROUP BY département
ORDER BY avg_diesel ASC
LIMIT 1;

-- @block
-- 6. Selectionner le carburant le plus souvent en rupture entre le mois de Janvier 2023 et Mars 2023
SELECT nom AS type_carburant, COUNT(nom) AS en_rupture FROM carburant AS c
JOIN  rupture AS r ON c.id = r.carburant_id
WHERE r.debut::TEXT > '2023-01%' -- préférer la fonction date pour comparer plutôt que text
AND r.fin::TEXT < '2023-03%'
GROUP BY c.nom
ORDER BY en_rupture DESC
LIMIT 1;

-- 6.a Selectionner le carburant le plus souvent en rupture entre le mois de Janvier 2023 et Mars 2023 à ANNECY
-- @block
SELECT nom AS type_carburant, COUNT(nom) AS en_rupture
FROM carburant AS c
    JOIN rupture AS r ON c.id = r.carburant_id
    JOIN point_de_vente AS pdv ON r.point_de_vente_id = pdv.id
WHERE r.debut::TEXT > '2023-01%'
    AND r.fin::TEXT < '2023-04%'
    AND pdv.ville = 'ANNECY'
GROUP BY type_carburant
ORDER BY en_rupture DESC
LIMIT 1;

-- 6.b Selectionner le carburant le plus souvent en rupture entre le mois de Janvier 2023 et Mars 2023 à ANNECY
-- @block
SELECT LEFT(pdv.code_postal, 2) AS dpt, COUNT(nom) AS en_rupture
FROM carburant AS c
    JOIN rupture AS r ON c.id = r.carburant_id
    JOIN point_de_vente AS pdv ON r.point_de_vente_id = pdv.id
WHERE r.debut >= date('2023-02-01')
    AND r.debut <= date('2023-03-31')
GROUP BY c.nom, dpt
ORDER BY en_rupture DESC
LIMIT 1;

-- 7. Sélectionner le point de vente et la date où le prix de l'E10 était le plus élevé
--@block
SELECT adresse, ville, date, p.valeur FROM point_de_vente AS pdv
JOIN prix AS p ON pdv.id = p.point_de_vente_id
JOIN carburant AS c ON c.id = p.carburant_id
WHERE c.nom = 'E10'
GROUP BY adresse, ville, date, p.valeur
ORDER BY max(p.valeur) DESC
LIMIT 1;


-- 8. Selectionner les stations d'autoroute
-- @block
SELECT * FROM point_de_vente
WHERE type = 'A';

-- 8.a Nombre de stations essences d'autoroute par département
-- @block
SELECT LEFT(code_postal, 2) AS cp, COUNT(*) AS nbr_pdv FROM point_de_vente
WHERE type = 'A'
GROUP BY cp
ORDER BY nbr_pdv DESC;


-- 9. Comparaison moyenne prix diesel autoroute vs route
-- @block
SELECT pdv.type, (SELECT nom FROM carburant WHERE nom = 'Gazole'), AVG(p.valeur)
FROM prix AS p
JOIN carburant AS c ON p.carburant_id = c.id
JOIN point_de_vente AS pdv ON p.point_de_vente_id = pdv.id
    WHERE c.nom = 'Gazole'
    AND date_part('Year', p.date) = 2023
    GROUP BY pdv.type;


-- 10. Sélection du nombre de jours ou un carburant coûtait entre 1.50€ et 1.80€ en 2014
-- @block
SELECT c.nom, COUNT(DISTINCT DATE_TRUNC('day', p.date)) FROM prix AS p
JOIN carburant AS c ON p.carburant_id = c.id
    WHERE p.valeur >= 1.50
    AND p.valeur <= 1.80
    AND extract(YEAR FROM p.date) = 2014
GROUP BY c.nom;

-- @block
SELECT c.nom, COUNT(DISTINCT DATE_TRUNC('day', p.date)) FROM prix AS p
JOIN carburant AS c ON p.carburant_id = c.id
WHERE p.valeur >= 1.50
  AND p.valeur <= 1.80
  AND extract(YEAR FROM p.date) = 2023
GROUP BY c.nom;

-- 11. Trouver une station essence sur l'autoroute autour de Lyon qui propose du Diesel et des toilettes publiques le 23/05/2023
-- @block
SELECT * FROM point_de_vente AS pdv
JOIN prix AS p ON pdv.id = p.point_de_vente_id
JOIN carburant AS c ON p.carburant_id = c.id
JOIN service_point_de_vente AS spdv ON pdv.id = spdv.point_de_vente_id
JOIN service AS s ON spdv.service_id = s.id
WHERE pdv.code_postal LIKE '69%'
AND pdv.type = 'A'
AND c.nom = 'Gazole'
AND s.nom = 'Toilettes publiques'
AND p.date >= '2023-05-23 00:00:00'
AND p.date <= '2023-05-23 12:00:00';


-- 12. Sélection de toutes les stations en rupture de Gazole au mois de Janvier 2023 mais qui possédaient toujours du SP95
SELECT pdv.adresse, pdv.ville, c.nom, r.debut, r.fin FROM point_de_vente AS pdv
JOIN rupture AS r ON pdv.id = r.point_de_vente_id
JOIN carburant AS c ON r.carburant_id = c.id
WHERE c.nom = 'SP95'
AND r.debut >= '2023-01-01'
AND r.fin < '2023-02-01'
ORDER BY r.debut;

-- rupture de diesel en janvier 2023
SELECT pdv.adresse, pdv.ville, c.nom, r.debut, r.fin FROM point_de_vente AS pdv
JOIN rupture AS r ON pdv.id = r.point_de_vente_id
JOIN carburant AS c ON r.carburant_id = c.id
WHERE c.nom = 'Gazole'
  AND r.debut >= '2023-01-01'
  AND r.fin < '2023-02-01'
ORDER BY r.debut;

-- 13. Sélection des stations service et les dates au mois d'Avril 2023 ou le prix du SP95 < moyenne prix du gazole
-- Moyenne du prix du Diesel en France en avril 2023
--@block
SELECT AVG(p.valeur) FROM prix AS p
JOIN carburant AS c on p.carburant_id = c.id
WHERE c.nom = 'Gazole'
  AND p.date >= '2023-04-01' AND p.date < '2023-05-01';


-- utiliser NOTEXISTS
--@block
SELECT pdv.adresse, pdv.ville, p.valeur AS sp95, (
    SELECT AVG(p.valeur) FROM prix AS p
    JOIN carburant AS c on p.carburant_id = c.id
    WHERE c.nom = 'Gazole'
    AND p.date >= '2023-04-01' AND p.date < '2023-05-01') AS diesel
FROM point_de_vente AS pdv
JOIN prix AS p ON pdv.id = p.point_de_vente_id
JOIN carburant AS c ON p.carburant_id = c.id
WHERE c.nom = 'SP95'
AND p.date >= '2023-04-01' AND p.date < '2023-05-01'
AND p.valeur < (
    SELECT AVG(p.valeur) FROM prix AS p
    JOIN carburant AS c on p.carburant_id = c.id
    WHERE c.nom = 'Gazole'
    AND p.date >= '2023-04-01' AND p.date < '2023-05-01');



