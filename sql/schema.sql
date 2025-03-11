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

DROP TABLE IF EXISTS SlotifyGroup;

CREATE TABLE SlotifyGroup ( -- A group of users form a slotify group
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name TEXT NOT NULL, -- slotifyGroup name
	UNIQUE(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserToSlotifyGroup;

CREATE TABLE UserToSlotifyGroup ( -- Many-to-many table linking users to slotifyGroups
        user_id INT UNSIGNED NOT NULL,
        slotify_group_id INT UNSIGNED NOT NULL,
	PRIMARY KEY(user_id, slotify_group_id), -- When starting with User
        INDEX      (slotify_group_id, user_id), -- When starting with SlotifyGroup
	CONSTRAINT fk_User_UserToSlotifyGroup FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
	CONSTRAINT fk_SlotifyGroup_UserToSlotifyGroup FOREIGN KEY (slotify_group_id) REFERENCES SlotifyGroup(id) ON DELETE CASCADE
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

DROP TABLE IF EXISTS Invite;

-- Table to represent a group join invite
CREATE TABLE Invite (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
        slotify_group_id INT UNSIGNED NOT NULL,
        from_user_id INT UNSIGNED NOT NULL,
        to_user_id INT UNSIGNED NOT NULL,
	message TEXT NOT NULL,
	status ENUM('pending', 'accepted', 'declined', 'expired') DEFAULT 'pending' NOT NULL,
	expiry_date DATE NOT NULL,
	created_at TIMESTAMP NOT NULL,
        INDEX      (slotify_group_id),
        INDEX      (to_user_id),
	CONSTRAINT fk_SlotifyGroup_Invite FOREIGN KEY (slotify_group_id) REFERENCES SlotifyGroup(id) ON DELETE CASCADE,
	CONSTRAINT fk_User_Invite_from FOREIGN KEY (from_user_id) REFERENCES User(id) ON DELETE CASCADE,
	CONSTRAINT fk_User_Invite_to FOREIGN KEY (to_user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS ReschedulingRequest;

-- Table to represent a rescheduling request
CREATE TABLE ReschedulingRequest (
	request_id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	requested_by INT UNSIGNED NOT NULL,
	status ENUM('pending', 'accepted', 'declined') DEFAULT 'pending' NOT NULL,
	created_at TIMESTAMP NOT NULL,
	CONSTRAINT fk_User_ReschedulingRequest FOREIGN KEY (requested_by) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS PlaceholderMeeting;

-- Table to represent a placeholder meeting
CREATE TABLE PlaceholderMeeting (
	meeting_id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	request_id INT UNSIGNED NOT NULL,
	title TEXT NOT NULL,
	start_time DATETIME NOT NULL,
	end_time DATETIME NOT NULL,
	location TEXT NOT NULL,
	duration TIME NOT NULL,
	start_date_range DATETIME NOT NULL,
	end_date_range DATETIME NOT NULL,
	CONSTRAINT fk_RequestID_PlaceholderMeeting FOREIGN KEY (request_id) REFERENCES ReschedulingRequest(request_id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS PlaceholderMeetingAttendee;

-- Many-to-many table linking placeholder meetings to users
CREATE TABLE PlaceholderMeetingAttendee (
	meeting_id INT UNSIGNED NOT NULL,
	user_id INT UNSIGNED NOT NULL,
	PRIMARY KEY(meeting_id, user_id), -- When starting with PlaceholderMeeting
		INDEX      (user_id, meeting_id), -- When starting with User
	CONSTRAINT fk_PlaceholderMeeting_PlaceholderMeetingAttendee FOREIGN KEY (meeting_id) REFERENCES PlaceholderMeeting(meeting_id) ON DELETE CASCADE,
	CONSTRAINT fk_User_PlaceholderMeetingAttendee FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS MeetingPreferences;

-- Table to represent a meeting preferences
CREATE TABLE MeetingPreferences (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	meeting_start_time DATETIME NOT NULL,
	start_date_range DATETIME NOT NULL,
	end_date_range DATETIME NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Meeting;

-- Table to represent a meeting
CREATE TABLE Meeting (
	id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
	meeting_pref_id INT UNSIGNED NOT NULL,
	owner_email VARCHAR(255) NOT NULL,
	msft_meeting_id TEXT NOT NULL,
	CONSTRAINT fk_Meeting_MeetingPreferences FOREIGN KEY (meeting_pref_id) REFERENCES MeetingPreferences(id) ON DELETE CASCADE
) ENGINE=InnoDB;


DROP TABLE IF EXISTS RequestToMeeting;

-- Table to create a one to one mapping between a request and a meeting
CREATE TABLE RequestToMeeting (
	request_id INT UNSIGNED NOT NULL PRIMARY KEY,
	meeting_id INT UNSIGNED NOT NULL,
	CONSTRAINT fk_RequestToMeeting_Request FOREIGN KEY (request_id) REFERENCES ReschedulingRequest(request_id) ON DELETE CASCADE,
	CONSTRAINT fk_RequestToMeeting_Meeting FOREIGN KEY (meeting_id) REFERENCES Meeting(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS UserPreferences;

-- Table to represent a user preferences
CREATE TABLE UserPreferences (
	user_id INT UNSIGNED NOT NULL PRIMARY KEY,
	lunch_start_time TIME NOT NULL,
	lunch_end_time TIME NOT NULL,
	CONSTRAINT fk_User_UserPreferences FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
) ENGINE=InnoDB;

