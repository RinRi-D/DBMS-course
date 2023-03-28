CREATE TABLE bank2 (id serial, username VARCHAR(50), fullname VARCHAR(50), balance numeric, Group_id int);
INSERT INTO bank2 (username, fullname, balance, Group_id) VALUES('jones', 'Alice Jones', 82, 1);
INSERT INTO bank2 (username, fullname, balance, Group_id) VALUES('bitdiddl', 'Ben Bitdiddle', 82, 1);
INSERT INTO bank2 (username, fullname, balance, Group_id) VALUES('mike', 'Michael Dole', 73, 2);
INSERT INTO bank2 (username, fullname, balance, Group_id) VALUES('alyssa', 'Alyssa P. Hacker', 79, 3);
INSERT INTO bank2 (username, fullname, balance, Group_id) VALUES('bbrown', 'Bob Brown', 100, 3);

-- Terminal 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * from bank2;
--  id | username |     fullname     | balance | group_id
-- ----+----------+------------------+---------+----------
--   1 | jones    | Alice Jones      |      82 |        1
--   2 | bitdiddl | Ben Bitdiddle    |      82 |        1
--   3 | mike     | Michael Dole     |      73 |        2
--   4 | alyssa   | Alyssa P. Hacker |      79 |        3
--   5 | bbrown   | Bob Brown        |     100 |        3
SELECT * from bank2;
--  id | username |     fullname     | balance | group_id
-- ----+----------+------------------+---------+----------
--   1 | jones    | Alice Jones      |      82 |        1
--   2 | bitdiddl | Ben Bitdiddle    |      82 |        1
--   3 | mike     | Michael Dole     |      73 |        2
--   4 | alyssa   | Alyssa P. Hacker |      79 |        3
--   5 | bbrown   | Bob Brown        |     100 |        3
-- Nothing changed after the change in second terminal

-- Terminal 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE bank2 SET username='ajones' WHERE fullname='Alice Jones';
SELECT * from bank2;
--  id | username |     fullname     | balance | group_id
-- ----+----------+------------------+---------+----------
--   2 | bitdiddl | Ben Bitdiddle    |      82 |        1
--   3 | mike     | Michael Dole     |      73 |        2
--   4 | alyssa   | Alyssa P. Hacker |      79 |        3
--   5 | bbrown   | Bob Brown        |     100 |        3
--   1 | ajones   | Alice Jones      |      82 |        1
-- The results are different because isolation level read commited allows to read only commited changes
COMMIT;
-- After commitment, they are the same

-- Term 1
UPDATE bank2 SET balance=balance+10 WHERE id=1;
-- Term 2
UPDATE bank2 SET balance=balance+20 WHERE id=1;
-- it waits the commitment from term 1
-- Term 1
COMMIT;
-- Term 2
ROLLBACK;

-- Repetable read
UPDATE bank2 SET username='jones' WHERE fullname='Alice Jones';
-- Term 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * from bank2;
SELECT * from bank2;
SELECT * from bank2;
UPDATE bank2 SET balance=balance+10 WHERE id=1;
COMMIT;

-- Term 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE bank2 SET username='ajones' WHERE fullname='Alice Jones';
COMMIT;
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE bank2 SET balance=balance+20 WHERE id=1;

-- Even after COMMIT on term 2, the data doesn't change on Term 1 because of the transaction isolation repetable read
-- Also after the balance change on the second term this error shows up:ERROR:  could not serialize access due to concurrent update

-- PART 2

-- TERM 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * from bank2 WHERE Group_id=2;
SELECT * from bank2 WHERE Group_id=2;
UPDATE bank2 SET balance=balance+15 WHERE Group_id=2;
-- Mike shows up


-- TERM 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE bank2 SET Group_id=2 WHERE username='bbrown';

-- BOB's balance hasn't change because when READ COMMITTED is set, it's impossible to view changes in other running transaction, so only balance of mike changed

-- REPEATABLE
UPDATE bank2 SET Group_id=3 WHERE username='bbrown';
-- TERM 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * from bank2 WHERE Group_id=2;
SELECT * from bank2 WHERE Group_id=2;
UPDATE bank2 SET balance=balance+15 WHERE Group_id=2;
-- Mike shows up


-- TERM 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE bank2 SET Group_id=2 WHERE username='bbrown';

-- THE same result
