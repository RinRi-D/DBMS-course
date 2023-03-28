-- PART A
CREATE TABLE accounts (id SERIAL, name VARCHAR(50), credit numeric, currency VARCHAR(10));
INSERT INTO accounts (name, credit, currency) VALUES('Account 1', 1000, 'RUB');
INSERT INTO accounts (name, credit, currency) VALUES('Account 2', 1000, 'RUB');
INSERT INTO accounts (name, credit, currency) VALUES('Account 3', 1000, 'RUB');

BEGIN;
	-- T1
	UPDATE accounts SET credit=credit-500 WHERE name='Account 1';
	UPDATE accounts SET credit=credit+500 WHERE name='Account 3';
	SAVEPOINT T1;

	-- T2
	UPDATE accounts SET credit=credit-700 WHERE name='Account 2';
	UPDATE accounts SET credit=credit+700 WHERE name='Account 1';
	SAVEPOINT T2;

	-- T3
	UPDATE accounts SET credit=credit-100 WHERE name='Account 2';
	UPDATE accounts SET credit=credit+100 WHERE name='Account 3';
	SAVEPOINT T3;

	ROLLBACK TO T3;
	ROLLBACK TO T2;
	ROLLBACK TO T1;

	ROLLBACK;

-- PART B
ALTER TABLE accounts ADD COLUMN BankName VARCHAR(30);
UPDATE accounts SET BankName='SberBank' WHERE name='Account 1' OR name='Account 3';
UPDATE accounts SET BankName='Tinkoff' WHERE name='Account 2';
INSERT INTO accounts (name, credit, currency) VALUES('Account 4', 1000, 'RUB');

BEGIN;
	-- T1
	UPDATE accounts SET credit=credit-500 WHERE name='Account 1';
	UPDATE accounts SET credit=credit+500 WHERE name='Account 3';
	DO
	$do$
	BEGIN
		IF (SELECT COUNT(DISTINCT BankName) FROM accounts WHERE name='Account 1' OR name='Account 3') >= 2 THEN
			UPDATE accounts SET credit=credit-30 WHERE name='Account 1';
			UPDATE accounts SET credit=credit+30 WHERE name='Account 4';
		END IF;
	END
	$do$;
	SAVEPOINT T1;

	-- T2
	UPDATE accounts SET credit=credit-700 WHERE name='Account 2';
	UPDATE accounts SET credit=credit+700 WHERE name='Account 1';
	DO
	$do$
	BEGIN
		IF (SELECT COUNT(DISTINCT BankName) FROM accounts WHERE name='Account 2' OR name='Account 1') >= 2 THEN
			UPDATE accounts SET credit=credit-30 WHERE name='Account 2';
			UPDATE accounts SET credit=credit+30 WHERE name='Account 4';
		END IF;
	END
	$do$;
	SAVEPOINT T2;

	-- T3
	UPDATE accounts SET credit=credit-100 WHERE name='Account 2';
	UPDATE accounts SET credit=credit+100 WHERE name='Account 3';
	DO
	$do$
	BEGIN
		IF (SELECT COUNT(DISTINCT BankName) FROM accounts WHERE name='Account 2' OR name='Account 3') >= 2 THEN
			UPDATE accounts SET credit=credit-30 WHERE name='Account 2';
			UPDATE accounts SET credit=credit+30 WHERE name='Account 4';
		END IF;
	END
	$do$;
	SAVEPOINT T3;

	ROLLBACK TO T3;
	ROLLBACK TO T2;
	ROLLBACK TO T1;

	ROLLBACK;

-- Part C
CREATE TABLE Ledger (id Serial, fromId int, toId int, fee numeric, amount numeric, transactionDateTime timestamp);
BEGIN;
	-- T1
	UPDATE accounts SET credit=credit-500 WHERE name='Account 1';
	UPDATE accounts SET credit=credit+500 WHERE name='Account 3';
	DO
	$do$
	BEGIN
		IF (SELECT COUNT(DISTINCT BankName) FROM accounts WHERE name='Account 1' OR name='Account 3') >= 2 THEN
			UPDATE accounts SET credit=credit-30 WHERE name='Account 1';
			UPDATE accounts SET credit=credit+30 WHERE name='Account 4';
			INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) Values(1, 3, 30, 500, CURRENT_TIMESTAMP);
		ELSE
			INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) Values(1, 3, 0, 500, CURRENT_TIMESTAMP);
		END IF;
	END
	$do$;
	SAVEPOINT T1;

	-- T2
	UPDATE accounts SET credit=credit-700 WHERE name='Account 2';
	UPDATE accounts SET credit=credit+700 WHERE name='Account 1';
	DO
	$do$
	BEGIN
		IF (SELECT COUNT(DISTINCT BankName) FROM accounts WHERE name='Account 2' OR name='Account 1') >= 2 THEN
			UPDATE accounts SET credit=credit-30 WHERE name='Account 2';
			UPDATE accounts SET credit=credit+30 WHERE name='Account 4';
			INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) Values(2, 1, 30, 700, CURRENT_TIMESTAMP);
		ELSE
			INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) Values(2, 1, 0, 700, CURRENT_TIMESTAMP);
		END IF;
	END
	$do$;
	SAVEPOINT T2;

	-- T3
	UPDATE accounts SET credit=credit-100 WHERE name='Account 2';
	UPDATE accounts SET credit=credit+100 WHERE name='Account 3';
	DO
	$do$
	BEGIN
		IF (SELECT COUNT(DISTINCT BankName) FROM accounts WHERE name='Account 2' OR name='Account 3') >= 2 THEN
			UPDATE accounts SET credit=credit-30 WHERE name='Account 2';
			UPDATE accounts SET credit=credit+30 WHERE name='Account 4';
			INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) Values(2, 4, 30, 100, CURRENT_TIMESTAMP);
		ELSE
			INSERT INTO Ledger (fromId, toId, fee, amount, transactionDateTime) Values(2, 4, 0, 100, CURRENT_TIMESTAMP);
		END IF;
	END
	$do$;
	SAVEPOINT T3;

	ROLLBACK TO T3;
	ROLLBACK TO T2;
	ROLLBACK TO T1;

	ROLLBACK;
