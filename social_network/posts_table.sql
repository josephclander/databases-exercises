CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  views int,
-- The foreign key name is always {other_table_singular}_id
  account_id int,
  constraint fk_accounts foreign key(account_id)
    references accounts(id)
--    on delete cascade
);