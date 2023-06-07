-- @block
DROP TABLE IF EXISTS `selling_point`;
DROP TABLE IF EXISTS `closing`;
DROP TABLE IF EXISTS `service`;
DROP TABLE IF EXISTS `selling_point_service`;
DROP TABLE IF EXISTS `open_hours`;
DROP TABLE IF EXISTS 'gas';
DROP TABLE IF EXISTS 'price';
DROP TABLE IF EXISTS `out_of`;

-- @block
CREATE TABLE `selling_point`(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    latitude REAL,
    longitude REAL,
    cp INTEGER,
    type TEXT CHECK (type IN ('A', 'R')) NOT NULL,
    address TEXT,
    city VARCHAR(150),
    automate BOOLEAN
);

-- @block
CREATE TABLE `closing`(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT CHECK (type IN ('O', 'C')) NOT NULL,
    start TEXT DEFAULT CURRENT_TIMESTAMP,
    end TEXT DEFAULT CURRENT_TIMESTAMP,
    selling_point_id INTEGER,
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id)
);

-- @block
CREATE TABLE `service`(
    name TEXT PRIMARY KEY
);

-- @block
CREATE TABLE `selling_point_service`(
    selling_point_id INTEGER,
    service_name TEXT,
    PRIMARY KEY (selling_point_id, service_name),
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id),
    FOREIGN KEY (service_name) REFERENCES service(name)
);

-- @block
CREATE TABLE `open_hours`(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    day TEXT,
    close_day BOOLEAN,
    open TEXT,
    close TEXT,
    selling_point_id INTEGER,
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id)
);

-- @block
CREATE TABLE `gas`(
    name TEXT PRIMARY KEY
);

-- @block
CREATE TABLE `price`(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    selling_point_id INTEGER,
    gas_name TEXT,
    value FLOAT,
    date TEXT,
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id),
    FOREIGN KEY (gas_name) REFERENCES gas(name)
);

-- @block
CREATE TABLE `out_of`(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    selling_point_id INTEGER,
    gas_name TEXT,
    start TEXT,
    end TEXT,
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id),
    FOREIGN KEY (gas_name) REFERENCES gas(name)
);


-- Insersion de données dans les tables
-- @block
INSERT INTO selling_point (latitude, longitude, cp, type, address, city, automate)
VALUES
    ('4491900', '487800', 26000, 'R', '162 AVENUE DE PROVENCE', 'VALENCE', 1),
    ('4491200', '491400', 26000, 'R', '362 RUE FAVENTINES', 'VALENCE', 1),
    ('4732555.47', '613314.06', 25640, 'A', 'AIRE DE CHAMPOUX', 'MARCHAUX', 1);
-- SELECT * FROM selling_point;

INSERT INTO closing (type, selling_point_id)
VALUES
    ('O', 1),
    ('C', 2),
    ('O', 3);
-- SELECT * FROM closing;

INSERT INTO service (name)
VALUES
    ('Toilettes publiques'),
    ('Douches'),
    ('Restauration'),
    ('Boutique alimentaire'),
    ('Station de gonflage');
-- SELECT * FROM service;

INSERT INTO selling_point_service(selling_point_id, service_name)
VALUES
    (1, 'Toilettes publiques'),
    (1, 'Boutique alimentaire'),
    (1, 'Station de gonflage'),
    (2, 'Toilettes publiques'),
    (2, 'Boutique alimentaire'),
    (3, 'Toilettes publiques'),
    (3, 'Douches'),
    (3, 'Restauration');
-- SELECT * FROM selling_point_service;

INSERT INTO open_hours(day, close_day, open, close, selling_point_id)
VALUES
    ('Lundi', 1, '08.00', '19.00', 1),
    ('Mardi', 1, '08.00', '19.00', 1),
    ('Mercredi', 1, '08.00', '19.00', 1),
    ('Jeudi', 1, '08.00', '19.00', 1),
    ('Vendredi', 1, '08.00', '19.00', 1),
    ('Samedi', 1, '08.00', '19.00', 1),
    ('Dimanche', 0, '08.00', '19.00', 1),
    ('Lundi', 1, '08.00', '19.00', 2),
    ('Mardi', 1, '08.00', '19.00', 2),
    ('Mercredi', 1, '08.00', '19.00', 2),
    ('Jeudi', 1, '08.00', '19.00', 2),
    ('Vendredi', 1, '08.00', '19.00', 2),
    ('Samedi', 1, '08.00', '19.00', 2),
    ('Dimanche', 0, '08.00', '19.00', 2),
    ('Lundi', 1, '00.00', '00.00', 3),
    ('Mardi', 1, '00.00', '00.00', 3),
    ('Mercredi', 1, '00.00', '00.00', 3),
    ('Jeudi', 1, '00.00', '00.00', 3),
    ('Vendredi', 1, '00.00', '00.00', 3),
    ('Samedi', 1, '00.00', '00.00', 3),
    ('Dimanche', 0, '00.00', '00.00', 3);
-- SELECT * FROM open_hours;

INSERT INTO gas(name)
VALUES
    ('SP98'),
    ('SP98 supreme+'),
    ('SP95'),
    ('E85'),
    ('E10'),
    ('Gazole'),
    ('Gazole supreme+'),
    ('GPLc');
-- SELECT * FROM gas;

INSERT INTO price (selling_point_id, gas_name, value, date)
VALUES
    (1, 'SP98', 1.986, datetime('now')),
    (1, 'SP95', 1.875, datetime('now')),
    (1, 'Gasole', 1.684, datetime('now')),
    (2, 'SP98', 1.986, datetime('now')),
    (2, 'SP95', 1.875, datetime('now')),
    (2, 'Gasole', 1.684, datetime('now')),
    (3, 'SP98', 1.986, datetime('now')),
    (3, 'SP95', 1.875, datetime('now')),
    (3, 'Gasole', 1.684, datetime('now'));
-- SELECT * FROM price;

INSERT INTO out_of (selling_point_id, gas_name, start, end)
VALUES
    (1, 'SP95', datetime('now'), datetime('now', '+10 day')),
    (3, 'SP98', datetime('now'), datetime('now' , '+1 day'));
--SELECT * FROM out_of;

-- @block
-- selectionner tous les éléments de selling_point, On joint les jours de fermeture avec pour relation l'id
-- concrètement : on cherche les informations sur les points de vente, et on souhaite savoir s'il sont ouverts ou fermés
SELECT * FROM selling_point
JOIN main.closing AS c -- utilisation de l'ALIAS c pour la table closing
ON selling_point.id = c.selling_point_id;

-- selectionner tous les éléments de selling_point, On joint les carburants en rupture avec pour relation l'id
-- concrètement : on cherche toutes les informations sur les points de vente qui sont en rupture de caburant (indiqué dans la table out_of)
SELECT * FROM selling_point
JOIN out_of AS oo -- on utilise oo comme ALIAS pour out_of
ON selling_point.id = oo.selling_point_id