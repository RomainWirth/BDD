-- @block
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Tweets;
DROP TABLE IF EXISTS Hashtags;
DROP TABLE IF EXISTS Users_users;
DROP TABLE IF EXISTS Tweets_users;
DROP TABLE IF EXISTS Hashtags_tweets;

-- @block
CREATE TABLE Users(
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name TEXT NOT NULL UNIQUE,
    user_email TEXT NOT NULL UNIQUE,
    user_address TEXT,
    user_postal_code INTEGER,
    user_city TEXT,
    user_country TEXT
);

-- @block
CREATE TABLE Tweets(
    tweet_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tweet_content TEXT NOT NULL,
    tweet_created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    u_id INTEGER NOT NULL,
    FOREIGN KEY(u_id) REFERENCES Users(user_id) 
);
-- @block
CREATE TABLE Hashtags(
    hashtag_name TEXT PRIMARY KEY
);

-- @block
CREATE TABLE Users_users(
    user1_id INTEGER,
    user2_id INTEGER,
    PRIMARY KEY(user1_id, user2_id),
    FOREIGN KEY(user1_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(user2_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- @block
CREATE TABLE Tweets_users(
    user_id INTEGER,
    tweet_id INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, tweet_id),
    FOREIGN KEY(user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE
);

-- @block
CREATE TABLE Hashtags_tweets(
    hashtag_name TEXT,
    tweet_id INTEGER,
    PRIMARY KEY(hashtag_name, tweet_id),
    FOREIGN KEY(hashtag_name) REFERENCES Hashtags(hashtag_name) ON DELETE CASCADE,
    FOREIGN KEY(tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE
);

-- @block
INSERT INTO Users (user_name, user_email, user_address, user_postal_code, user_city, user_country)
VALUES
    ('Toto', 'toto@domaine.com', '123 nous irons aux bois', 78000, 'PARIS', 'FRANCE'),
    ('OuiOui', 'ouioui@domaine.com', '456 cueillir des cerises', 69000, 'LYON', 'FRANCE'),
    ('NonNon', 'nonnon@domaine.com', '789 dans mon panier neuf', 74000, 'ANNECY', 'FRANCE');
-- SELECT * FROM Users;

-- @block
INSERT INTO Tweets (tweet_content, u_id)
VALUES
    ('tweet 1 Toto', 1),
    ('tweet 2 Toto', 1),
    ('tweet 3 Toto', 1),
    ('tweet 1 OuiOui', 2),
    ('tweet 2 OuiOui', 2),
    ('tweet 3 OuiOui', 2),
    ('tweet 1 NonNon', 3),
    ('tweet 2 NonNon', 3),
    ('tweet 3 NonNon', 3);
-- SELECT * FROM Tweets;

-- @block
INSERT INTO Tweets_users (user_id, tweet_id)
VALUES 
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 7),
    (2, 8),
    (2, 9),
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4),
    (3, 5),
    (3, 6);
-- SELECT * FROM Tweets_users;