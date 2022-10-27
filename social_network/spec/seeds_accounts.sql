TRUNCATE TABLE accounts RESTART IDENTITY CASCADE; -- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO accounts (username, email) VALUES ('joelander', 'joe@test.com');
INSERT INTO accounts (username, email) VALUES ('iainhoolahan', 'iain@test.com');