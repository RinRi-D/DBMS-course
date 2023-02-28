-- EXERCISE 1
-- I inserted everything manually

CREATE TABLE customers (
    customerId INT,
    customerName VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (customerId)
);

CREATE TABLE items (
    itemId INT,
    itemName VARCHAR(50),
    price FLOAT,
    PRIMARY KEY (itemId)
);

CREATE TABLE orders (
    orderId INT,
    customerId INT,
    date DATE,
    FOREIGN KEY (customerId) REFERENCES customers(customerId),
    PRIMARY KEY (orderId)
);

CREATE TABLE order_details (
    orderId INT,
    itemId INT,
    quantity INT,
    FOREIGN KEY (itemId) REFERENCES items(itemId),
    PRIMARY KEY (orderId, itemId)
);

INSERT INTO customers VALUES('101', 'Martin', 'Prague');
INSERT INTO customers VALUES('107', 'Herman', 'Madrid');
INSERT INTO customers VALUES('110', 'Pedro', 'Moscow');

INSERT INTO items VALUES('3786', 'Net', 35.0);
INSERT INTO items VALUES('4011', 'Racket', 65.0);
INSERT INTO items VALUES('9132', 'Pack-3', 4.75);
INSERT INTO items VALUES('5794', 'Pack-6', 5.0);
INSERT INTO items VALUES('3141', 'Cover', 10.0);

INSERT INTO orders VALUES('2301', '101', '2011-02-23');
INSERT INTO orders VALUES('2302', '107', '2011-02-25');
INSERT INTO orders VALUES('2303', '110', '2011-02-27');

INSERT INTO order_details VALUES ('2301', '3786', 3);
INSERT INTO order_details VALUES ('2301', '4011', 6);
INSERT INTO order_details VALUES ('2301', '9132', 8);
INSERT INTO order_details VALUES ('2302', '5794', 4);
INSERT INTO order_details VALUES ('2303', '4011', 2);
INSERT INTO order_details VALUES ('2303', '3141', 2);

SELECT order_details.orderId, SUM(items.price * order_details.quantity)
FROM order_details
INNER JOIN items on items.itemId=order_details.itemId
group by order_details.orderId ORDER BY sum ASC;


SELECT customers.customerName, customers.city FROM customers
INNER JOIN orders ON customers.customerId=orders.customerId
INNER JOIN order_details ON order_details.orderId=orders.orderId
GROUP BY customers.customerId
ORDER BY SUM(order_details.quantity) DESC
LIMIT 1;

-- Exercise 2
-- Automated insert

CREATE TABLE loan_books
	(school VARCHAR(50),
    teacher VARCHAR(30),
    course VARCHAR(40),
    room VARCHAR(10),
    grade VARCHAR(15),
    book VARCHAR(60),
    publisher VARCHAR(30),
    loanDate DATE,
	PRIMARY KEY (school, teacher, course)
	);
	
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'Chad Russell', 'Logical Thinking', '1.A01', '1st grade', 'Learning and teaching in early childhood education', 'BOA Editions', '2010-09-09');
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'Chad Russell', 'Writing', '1.A01', '1st grade', 'Preschool, N56', 'Taylor & Francis Publishing', '2010-05-05');
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'Chad Russell', 'Numerical thinking', '1.A01', '1st grade', 'Learning and teaching in early childhood education', 'BOA Editions', '2010-05-05');
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'E.F.Codd', 'Spatial, Temporal and Causal Thinking', '1.B01', '1st grade', 'Early Childhood Education N9', 'Prentice Hall', '2010-05-06');
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'E.F.Codd', 'Numerical thinking', '1.B01', '1st grade', 'Learning and teaching in early childhood education', 'BOA Editions', '2010-05-06');
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'Jones Smith', 'Writing', '1.A01', '2nd grade', 'Learning and teaching in early childhood education', 'BOA Editions', '2010-09-09');
INSERT INTO loan_books VALUES ('Horizon Education Institute', 'Jones Smith', 'English', '1.A01', '2nd grade', 'Know how to educate: guide for Parents and Teachers', 'McGraw Hill', '2010-05-05');
INSERT INTO loan_books VALUES ('Bright Institution', 'Adam Baker', 'Logical Thinking', '2.B01', '1st grade', 'Know how to educate: guide for Parents and Teachers', 'McGraw Hill', '2010-12-18');
INSERT INTO loan_books VALUES ('Bright Institution', 'Adam Baker', 'Numerical Thinking', '2.B01', '1st grade', 'Learning and teaching in early childhood education', 'BOA Editions', '2010-05-06');

CREATE TABLE schools (
    schoolId SERIAL,
    schoolName VARCHAR(50),
    PRIMARY KEY (schoolId)
);

CREATE TABLE teachers (
    teacherId SERIAL,
    teacherName VARCHAR(30),
    PRIMARY KEY (teacherId)
);

CREATE TABLE courses (
    courseId SERIAL,
    courseName VARCHAR(40),
    PRIMARY KEY (courseId)
);

CREATE TABLE rooms (
    roomId SERIAL,
    roomName VARCHAR(40),
    PRIMARY KEY (roomId)
);

CREATE TABLE grades (
    gradeId SERIAL,
    gradeName VARCHAR(15),
    PRIMARY KEY (gradeId)
);

CREATE TABLE publishers (
    publisherId SERIAL,
    publisherName VARCHAR(30),
    PRIMARY KEY (publisherId)
);

CREATE TABLE books (
    bookId SERIAL,
    bookName VARCHAR(60),
    publisherId INT,
    FOREIGN KEY (publisherId) REFERENCES publishers(publisherId),
    PRIMARY KEY (bookId)
);

CREATE TABLE lessons (
    lessonId SERIAL,
    schoolId INT,
    teacherId INT,
    courseId INT,
    roomId INT,
    gradeId INT,
    FOREIGN KEY (teacherId) REFERENCES teachers(teacherId),
    FOREIGN KEY (courseId) REFERENCES courses(courseId),
    FOREIGN KEY (roomId) REFERENCES rooms(roomId),
    FOREIGN KEY (gradeId) REFERENCES grades(gradeId),
    PRIMARY KEY (lessonId)
);

CREATE TABLE loans (
    loanId SERIAL,
    lessonId INT,
    bookId INT,
    loanDate DATE,
    FOREIGN KEY (lessonId) REFERENCES lessons(lessonId),
    FOREIGN KEY (bookId) REFERENCES books(bookId),
    PRIMARY KEY (loanId)
);

INSERT INTO schools (schoolName) SELECT DISTINCT school FROM loan_books;
INSERT INTO teachers (teacherName) SELECT DISTINCT teacher FROM loan_books;
INSERT INTO courses (courseName) SELECT DISTINCT course FROM loan_books; -- Inserted Numerical thinking 2 times because of case sensitivity. Not gonna change anything.
INSERT INTO rooms (roomName) SELECT DISTINCT room FROM loan_books;
INSERT INTO grades (gradeName) SELECT DISTINCT grade FROM loan_books;
INSERT INTO publishers (publisherName) SELECT DISTINCT publisher FROM loan_books;
INSERT INTO books (bookName, publisherId) SELECT DISTINCT loan_books.book, publishers.publisherId FROM loan_books INNER JOIN publishers ON publishers.publisherName=loan_books.publisher;

INSERT INTO lessons (schoolId, teacherId, courseId, roomId, gradeId) SELECT DISTINCT schools.schoolId, teachers.teacherId, courses.courseId, rooms.roomId, grades.gradeId FROM loan_books
    INNER JOIN schools ON schools.schoolName=loan_books.school
    INNER JOIN teachers ON teachers.teacherName=loan_books.teacher
    INNER JOIN courses ON courses.courseName=loan_books.course
    INNER JOIN rooms ON rooms.roomName=loan_books.room
    INNER JOIN grades ON grades.gradeName=loan_books.grade;

INSERT INTO loans (lessonId, bookId, loanDate) SELECT DISTINCT lessons.lessonId, books.bookId, loan_books.loanDate FROM loan_books
    INNER JOIN schools ON schools.schoolName=loan_books.school
    INNER JOIN teachers ON teachers.teacherName=loan_books.teacher
    INNER JOIN courses ON courses.courseName=loan_books.course
    INNER JOIN rooms ON rooms.roomName=loan_books.room
    INNER JOIN grades ON grades.gradeName=loan_books.grade
    INNER JOIN books ON books.bookName=loan_books.book
    INNER JOIN lessons ON lessons.gradeId=grades.gradeId and lessons.roomId=rooms.roomId and lessons.courseId=courses.courseId and lessons.teacherId=teachers.teacherId;

SELECT DISTINCT publishers.publisherName, books.bookName, schools.schoolName FROM books
    INNER JOIN loans ON loans.bookId=books.bookId
    INNER JOIN lessons ON lessons.lessonId=loans.lessonId
    INNER JOIN schools ON schools.schoolId=lessons.schoolId
    INNER JOIN publishers ON publishers.publisherId=books.publisherId
    ORDER BY publishers.publisherName;

SELECT DISTINCT ON (schools.schoolName) schools.schoolName, publishers.publisherName, books.bookName, loans.loanDate FROM loans
    INNER JOIN lessons ON lessons.lessonId=loans.lessonId
    INNER JOIN schools ON schools.schoolId=lessons.schoolId
    INNER JOIN books ON books.bookId=loans.bookId
    INNER JOIN publishers ON publishers.publisherId=books.publisherId
    ORDER BY schools.schoolName, loans.loanDate DESC, 1;
