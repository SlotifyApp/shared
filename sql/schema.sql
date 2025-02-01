DROP DATABASE IF EXISTS slotify;
CREATE DATABASE slotify;
USE slotify;

DROP TABLE IF EXISTS User;

CREATE TABLE User (-- Stores user details
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	email VARCHAR(255) NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	UNIQUE(email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Team;

CREATE TABLE Team ( -- A group of users form a team (eg. a council)
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(255) NOT NULL, -- team name
	UNIQUE(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserToTeam;

CREATE TABLE UserToTeam ( -- Many-to-many table linking users to teams
        user_id INT UNSIGNED NOT NULL,
        team_id INT UNSIGNED NOT NULL, 
	PRIMARY KEY(user_id, team_id), -- When starting with User
        INDEX      (team_id, user_id), -- When starting with Team
	CONSTRAINT fk_User_UserToTeam FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
	CONSTRAINT fk_Team_UserToTeam FOREIGN KEY (team_id) REFERENCES Team(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserToMSFTRefreshToken;

CREATE TABLE UserToMSFTRefreshToken (-- Stores a user's microsoft refresh token
        user_id INT UNSIGNED NOT NULL,
        token TEXT NOT NULL, -- At least 500 chars, may increase
	UNIQUE(user_id),
	CONSTRAINT fk_User_UserToMicrosoftRefreshToken FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;


DROP TABLE IF EXISTS RefreshToken;

CREATE TABLE RefreshToken( -- RefreshToken stores details about Slotify's Refresh Token
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	token TEXT NOT NULL,
	expires_at TIMESTAMP NOT NULL,
	revoked BOOLEAN DEFAULT FALSE,
	UNIQUE(user_id),
	UNIQUE(token),
	CONSTRAINT fk_User_RefreshToken FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;
