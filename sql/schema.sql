DROP DATABASE IF EXISTS slotify;
CREATE DATABASE slotify;
USE slotify;

DROP TABLE IF EXISTS User;

CREATE TABLE User (
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

CREATE TABLE UserToTeam ( -- Many-to-many table
        user_id INT UNSIGNED NOT NULL,
        team_id INT UNSIGNED NOT NULL, 
	PRIMARY KEY(user_id, team_id), -- When starting with User
        INDEX      (team_id, user_id), -- When starting with Team
	CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
	CONSTRAINT fk_team FOREIGN KEY (team_id) REFERENCES Team(id) ON DELETE CASCADE
) ENGINE=InnoDB;
