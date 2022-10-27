-- (RESTART IDENTITY resets the primary key)

-- TRUNCATE TABLE accounts RESTART IDENTITY; -- replace with your own table name.
TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
-- INSERT INTO accounts (username, email) VALUES ('joelander', 'joe@test.com');
-- INSERT INTO accounts (username, email) VALUES ('iainhoolahan', 'iain@test.com');

INSERT INTO posts (title, content, views, account_id) VALUES ('day1', 'some content', 5, 1);
INSERT INTO posts (title, content, views, account_id) VALUES ('day2', 'some more content', 10, 2);