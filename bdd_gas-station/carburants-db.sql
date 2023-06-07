-- @block
DROP TABLE IF EXISTS `selling_point`;
DROP TABLE IF EXISTS `closing`;
DROP TABLE IF EXISTS `service`;
DROP TABLE IF EXISTS `selling_point_service`;
DROP TABLE IF EXISTS `open_hours`;


-- @block
CREATE TABLE `selling_point`(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    latitude REAL,
    longitude REAL,
    cp INTEGER,
    type VARCHAR(1),
    address TEXT,
    city VARCHAR(150),
    automate INTEGER
);

-- @block
CREATE TABLE `closing`(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    type VARCHAR, -- vérifier ce qui est impliqué avec cette colonne
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
    close_day INTEGER,
    open TEXT DEFAULT CURRENT_TIME,
    close TEXT DEFAULT CURRENT_TIME,
    selling_point_id INTEGER,
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id)
);

-- @block
CREATE TABLE `gas`(
    name TEXT PRIMARY KEY
);

-- @block
CREATE TABLE `price`(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    value FLOAT,
    date TEXT DEFAULT CURRENT_TIMESTAMP,
    selling_point_id INTEGER,
    gas_name TEXT,
    FOREIGN KEY (selling_point_id) REFERENCES selling_point(id),
    FOREIGN KEY (gas_name) REFERENCES gas(name)
);