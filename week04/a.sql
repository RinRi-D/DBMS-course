CREATE TABLE University(
  name VARCHAR(50),
  location VARCHAR(50),
  primary key (name)
);

CREATE TABLE Student(
  id INTEGER UNIQUE,
  name VARCHAR(50),
  nativeLanguage VARCHAR(50),
  universityName VARCHAR(50),
  foreign key (universityName) REFERENCES University(name),
  primary key (id)
);

CREATE TABLE Course(
  name VARCHAR(50),
  credits INTEGER,
  universityName VARCHAR(50),
  foreign key (universityName) REFERENCES University(name),
  primary key (name)
);

CREATE TABLE Enrollment(
  studentId INTEGER,
  courseName VARCHAR(50),
  foreign key (studentId) REFERENCES Student(id),
  foreign key (courseName) REFERENCES Course(name),
  primary key (studentId, courseName)
);

INSERT INTO UNIVERSITY (name, location) VALUES ('Innopolis', 'Russia');
INSERT INTO UNIVERSITY (name, location) VALUES ('NU', 'Kazakhstan');
INSERT INTO UNIVERSITY (name, location) VALUES ('KBTU', 'Kazakhstan');
INSERT INTO UNIVERSITY (name, location) VALUES ('KFU', 'Russia');

INSERT INTO STUDENT (id, name, nativeLanguage, universityName) VALUES (1, 'Amirlan', 'Russian', 'Innopolis');
INSERT INTO STUDENT (id, name, nativeLanguage, universityName) VALUES (2, 'RANDOMDUDE', 'Russian', 'KFU');
INSERT INTO STUDENT (id, name, nativeLanguage, universityName) VALUES (3, 'Arslan', 'Russian', 'KBTU');
INSERT INTO STUDENT (id, name, nativeLanguage, universityName) VALUES (4, 'Madi', 'Russian', 'NU');
INSERT INTO STUDENT (id, name, nativeLanguage, universityName) VALUES (5, 'Jacob', 'English', 'Innopolis');

INSERT INTO Course (name, credits, universityName) VALUES ('AGLA', 1, 'Innopolis');
INSERT INTO Course (name, credits, universityName) VALUES ('MA1', 10, 'Innopolis');
INSERT INTO Course (name, credits, universityName) VALUES ('ITP1', 1, 'Innopolis');
INSERT INTO Course (name, credits, universityName) VALUES ('CS101', 1, 'NU');
INSERT INTO Course (name, credits, universityName) VALUES ('Physics', 1, 'KBTU');
INSERT INTO Course (name, credits, universityName) VALUES ('PE', 1, 'KFU');

INSERT INTO Enrollment (studentId, courseName) VALUES (1, 'AGLA');
INSERT INTO Enrollment (studentId, courseName) VALUES (1, 'MA1');
INSERT INTO Enrollment (studentId, courseName) VALUES (1, 'ITP1');
INSERT INTO Enrollment (studentId, courseName) VALUES (5, 'ITP1');
INSERT INTO Enrollment (studentId, courseName) VALUES (2, 'PE');
INSERT INTO Enrollment (studentId, courseName) VALUES (3, 'Physics');
INSERT INTO Enrollment (studentId, courseName) VALUES (4, 'CS101');

SELECT * FROM University WHERE location='Russia';
SELECT location FROM University WHERE location!='Russia' AND name IN (
  SELECT universityName FROM Student WHERE nativeLanguage='Russian'
);
SELECT id FROM Student WHERE universityName='Innopolis';
SELECT name, universityName FROM Course WHERE credits>5;
SELECT * FROM University WHERE name IN (
  SELECT universityName FROM Student WHERE nativeLanguage='English'
);
