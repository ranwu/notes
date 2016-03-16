/*description: Create a database and table
 *author: Mike Chen
 *date: 2016.03.14
 */

-- 创建论坛数据库
CREATE DATABASE forum
CHARACTER SET utf8
COLLATE utf8_general_ci;
USE forum;

-- 创建forum表
CREATE TABLE forums (
forum_id TINYINT UNSIGNED NOT NULL
AUTO_INCREMENT,
name VARCHAR(60) NOT NULL,
PRIMARY KEY (forum_id),
UNIQUE (name)
) ENGINE=INNODB;

-- 创建message表
CREATE TABLE message (
message_id INT UNSIGNED NOT NULL 
AUTO_INCREMENT,
parent_id INT UNSIGNED NOT NULL DEFAULT 0,
forum_id TINYINT UNSIGNED NOT NULL,
user_id MEDIUMINT UNSIGNED NOT NULL,
subject VARCHAR(100) NOT NULL,
body LONGTEXT NOT NULL,
date_entered DATETIME NOT NULL,
PRIMARY KEY (message_id),
INDEX (parent_id),
INDEX (forum_id),
INDEX (user_id),
INDEX (date_entered),
) ENGINE=MYISAM;

--创建users表
CREATE TABLE users (
user_id MEDIUMINT UNSIGNED NOT NULL 
AUTO_INCREMENT,
username VARCHAR(30) NOT NULL,
pass CHAR(40) NOT NULL,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(40) NOT NULL,
email VARCHAR(60) NOT NULL,
PRIMARY KEY (user_id),
UNIQUE (username),
UNIQUE (email),
INDEX login (pass, email)
) ENGINE = INNODB;


