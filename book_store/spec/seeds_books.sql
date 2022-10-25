-- EXAMPLE
-- (file: spec/seeds_books.sql)

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE books RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO books (title, author_name) VALUES ('The Picture of Dorian Gray', 'Oscar Wilde');
INSERT INTO books (title, author_name) VALUES ('Pride and Prejudice', 'Jane Austen');