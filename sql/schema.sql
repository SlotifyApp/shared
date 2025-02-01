DROP DATABASE IF EXISTS slotify;
CREATE DATABASE slotify;
USE slotify;

DROP TABLE IF EXISTS Role;

CREATE TABLE Role (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`name` VARCHAR(255) NOT NULL,
	`level` INT NOT NULL, -- lower is more important
	`description` TEXT
) ENGINE=InnoDB;

DROP TABLE IF EXISTS User;

CREATE TABLE User (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	email VARCHAR(255) NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	UNIQUE(email)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserToRole;

CREATE TABLE UserToRole (
	user_id INT UNSIGNED NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	PRIMARY KEY(user_id, role_id),
	CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
	CONSTRAINT kf_role_id FOREIGN KEY (role_id) REFERENCES Role(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserPreferenceDays;

CREATE TABLE UserPreferenceDays ( -- null = all for sets
	user_id INT UNSIGNED NOT NULL,
	`days` SET('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') DEFAULT NULL,
	PRIMARY KEY(user_id),
	CONSTRAINT fk_user_days FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserPreferenceMeetingTypes;

CREATE TABLE UserPreferenceMeetingTypes ( -- null = all for sets
	user_id INT UNSIGNED NOT NULL,
	meeting_types SET("one-to-one", "small-department", "public", "manager", "sponsor") DEFAULT NULL,
	PRIMARY KEY(user_id),
	CONSTRAINT fk_user_meeting_types FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserPreferenceBuffer;

CREATE TABLE UserPreferenceBuffer ( -- null = all for sets
	user_id INT UNSIGNED NOT NULL,
	`buffer` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY(user_id, buffer),
	CONSTRAINT fk_user_buffer FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
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
	`name` VARCHAR(255) NOT NULL,
	capacity INT NOT NULL,
	`location` VARCHAR(255),
	UNIQUE(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Equipment;

CREATE TABLE Equipment (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`name` VARCHAR(255) NOT NULL,
	quantity INT NOT NULL,
	UNIQUE(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS RoomEquipment;

CREATE TABLE RoomEquipment ( -- many-to-many
	room_id INT UNSIGNED NOT NULL,
	equipment_id INT UNSIGNED NOT NULL,
	PRIMARY KEY(room_id, equipment_id),
	INDEX(equipment_id, room_id),
	CONSTRAINT fk_room_equipment FOREIGN KEY (room_id) REFERENCES Room(id) ON DELETE CASCADE,
	CONSTRAINT fk_equipment_room FOREIGN KEY (equipment_id) REFERENCES Equipment(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS MeetingType;

CREATE TABLE MeetingType (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Meeting;

CREATE TABLE Meeting (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`name` VARCHAR(255) NOT NULL,
	meeting_description TEXT,
	meeting_date DATE NOT NULL,
	room_id INT UNSIGNED NOT NULL,
	starting_time TIME NOT NULL,
	ending_time TIME NOT NULL,
	number_of_people INT UNSIGNED NOT NULL CHECK (number_of_people > 0),
	organizer_id INT UNSIGNED NOT NULL,
	meeting_type_id INT UNSIGNED NOT NULL,
	highest_role_id INT UNSIGNED NOT NULL,
	CONSTRAINT fk_meeting_room FOREIGN KEY (room_id) REFERENCES Room(id) ON DELETE CASCADE,
	CONSTRAINT fk_meeting_organizer FOREIGN KEY (organizer_id) REFERENCES Team(id) ON DELETE CASCADE,
	CONSTRAINT fk_meeting_type FOREIGN KEY (meeting_type_id) REFERENCES MeetingType(id) ON DELETE CASCADE,
	CONSTRAINT fk_highest_role FOREIGN KEY (highest_role_id) REFERENCES Role(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS MeetingParticipant;

CREATE TABLE MeetingParticipant (
	meeting_id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED NOT NULL,
	mandatory BOOLEAN NOT NULL DEFAULT TRUE, -- whether the participant is mandatory at meeting
	PRIMARY KEY(meeting_id, user_id),
	CONSTRAINT fk_meeting_participant FOREIGN KEY (meeting_id) REFERENCES Meeting(id) ON DELETE CASCADE,
	CONSTRAINT fk_participant_meeting FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;