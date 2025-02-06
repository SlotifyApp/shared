CREATE DATABASE IF NOT EXISTS slotify;
USE slotify;

DROP TABLE IF EXISTS User;

CREATE TABLE User (-- Stores user details
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	email VARCHAR(255) NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	msft_home_account_id VARCHAR(255),
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

DROP TABLE IF EXISTS RefreshToken;

CREATE TABLE RefreshToken( -- RefreshToken stores details about Slotify's Refresh Token
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	token TEXT NOT NULL,
	revoked BOOLEAN DEFAULT FALSE NOT NULL,
	UNIQUE(user_id),
	UNIQUE(token),
	CONSTRAINT fk_User_RefreshToken FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Notification;

CREATE TABLE Notification ( -- Notification stores details about a notification
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	message TEXT NOT NULL,
	created TIMESTAMP NOT NULL
) ENGINE=InnoDB;


DROP TABLE IF EXISTS UserToNotification;

-- Many-to-many table linking users to notifications, users can share a notification eg. reschedule
CREATE TABLE UserToNotification (
        user_id INT UNSIGNED NOT NULL,
        notification_id INT UNSIGNED NOT NULL,
	is_read BOOL DEFAULT FALSE NOT NULL,
	PRIMARY KEY(user_id, notification_id), -- When starting with User
        INDEX      (notification_id, user_id), -- When starting with Notification
	CONSTRAINT fk_User_UserToNotification FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
	CONSTRAINT fk_Notification_UserToNotification FOREIGN KEY (notification_id) REFERENCES Notification(id) ON DELETE CASCADE
) ENGINE=InnoDB;
