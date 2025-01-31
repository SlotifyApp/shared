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
	`name` VARCHAR(255) NOT NULL, -- team name
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

DROP TABLE IF EXISTS Room;

CREATE TABLE Room (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`name` VARCHAR(225) NOT NULL,
	capacity INT NOT NULL,
	`location` VARCHAR(225),
	UNIQUE(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Equipment;

CREATE TABLE Equipment (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`name` VARCHAR(225) NOT NULL,
	quantity INT NOT NULL,
	UNIQUE(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS RoomEquiment;

CREATE TABLE RoomEquiment ( -- many-to-many
	room_id INT UNSIGNED NOT NULL,
	equipment_id INT UNSIGNED NOT NULL,
	PRIMARY KEY(room_id, equipment_id),
	INDEX(equipment_id, room_id),
	CONSTRAINT fk_room_equipment FOREIGN KEY (room_id) REFERENCES Room(id) ON DELETE CASCADE,
	CONSTRAINT fk_equipment_room FOREIGN KEY (equipment_id) REFERENCES Equipment(id) ON DELETE CASCADE,
) ENGINE=InnoDB;

DROP TABLE IF EXISTS EventType;

CREATE TABLE EventType (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS PublicEvent;

CREATE TABLE PublicEvents (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	public_event_name VARCHAR(225) NOT NULL,
	public_event_description TEXT,
	public_event_date DATE NOT NULL,
	room_id INT UNSIGNED NOT NULL,
	starting_time TIME NOT NULL,
	ending_time TIME NOT NULL,	
	organizer_id INT UNSIGNED NOT NULL,
	event_type_id INT UNSIGNED NOT NULL,
	CONSTRAINT fk_event_room FOREIGN KEY (room_id) REFERENCES Room(id) ON DELETE CASCADE,
	CONSTRAINT fk_event_organizer FOREIGN KEY (organizer_id) REFERENCES Team(id) ON DELETE CASCADE,
	CONSTRAINT fk_event_type FOREIGN KEY (event_type_id) REFERENCES EventType(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS EventParticipant;

CREATE TABLE EventParticipant (
	event_id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED NOT NULL,
	mandatory BOOLEAN NOT NULL DEFAULT TRUE, -- whether the participant is mandatory at event
	PRIMARY KEY(event_id, user_id),
	CONSTRAINT fk_event_participant FOREIGN KEY (event_id) REFERENCES PublicEvent(id) ON DELETE CASCADE,
	CONSTRAINT fk_participant_event FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;