# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

_In this template, we'll use an example table `students`_

```
# EXAMPLE
Table: accounts
Columns:
id | email | username

Table: posts
Columns:
id | title | content | views | account_id

```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)
-- Write your SQL seed here.
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)
TRUNCATE TABLE accounts RESTART IDENTITY; -- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO accounts (username, email) VALUES ('joelander', 'joe@test.com');
INSERT INTO accounts (username, email) VALUES ('iainhoolahan', 'iain@test.com');






-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, views, account_id) VALUES ('day1', 'some content', 5, '1');
INSERT INTO posts (title, content, views, account_id) VALUES ('day2', 'some more content', 10, '2');

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < seeds_accounts.sql
psql -h 127.0.0.1 social_network_test < seeds_posts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: accounts
# Model class
# (in lib/account.rb)
class Account
end
# Repository class
# (in lib/account_repository.rb)
class AccountRepository
end


# (in lib/post.rb)
class Post
end
# Repository class
# (in lib/post_repository.rb)
class PostRepository
end


```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students
# Model class
# (in lib/account.rb)
class Account
  # Replace the attributes by your own columns.
  attr_accessor :id, :email, :username
end
# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name

# (in lib/post.rb)
class Post
  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :views, :account_id
end

```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: accounts
# Repository class
# (in lib/account_repository.rb)
class AccountRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email, username FROM accounts;
    # Returns an array of Account objects.
  end
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email, username FROM accounts WHERE id = $1;
    # Returns a single Account object.
  end

  # creates an account
  # with an account object
  def create(account)
  # Executes the SQL query:
  # INSERT INTO accounts (email, username) VALUES ($1, $2);

  #returns nothing
  end

  # delete an account
  # with an account object
  def delete(id)
  # Executes the SQL query:
  # DELETE FROM accounts WHERE id = $1;

  # returns nothing
  end
end
```

```ruby
# EXAMPLE
# Table name: posts
# Repository class
# (in lib/post_repository.rb)
class PostRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, account_id FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, views, account_id FROM posts WHERE id = $1;

    # Returns a single Post object.
  end

  # creates an post
  # with an post object
  def create(post)
  # Executes the SQL query:
  # INSERT INTO posts (title, content, views) VALUES ($1, $2, $3);

  #returns nothing
  end

  # delete an post
  # with an post object
  def delete(id)
  # Executes the SQL query:
  # DELETE FROM posts WHERE id = $1;

  # returns nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
# 1
# Get all accounts
repo = AccountRepository.new
accounts = repo.all
accounts.length # =>  2
accounts[0].id # =>  1
accounts[0].username # =>  'joelander'
accounts[0].email # =>  'joe@test.com'
accounts[1].id # =>  2
accounts[1].username # =>  'iainhoolahan'
accounts[1].email # =>  'iain@test.com'

# 2
# Get a single account
repo = AccountRepository.new
accounts = repo.find(1)
accounts.id # =>  1
accounts.username # =>  'joelander'
accounts.email # =>  'joe@test.com'

# 3
# create an account
repo = AccountRepository.new
new_account = Account.new
new_account.email = 'adon@test.com'
new_account.username = 'adonlawley'

repo.create(new_account) # => nil

accounts = repo.all
last_account = accounts.last

expect(last_account.email).to eq 'adon@test.com'
expect(last_account.username).to eq 'adonlawley'

# 4
# delete an account
repo = AccountRepository.new
repo.delete(1)

result_set = repo.all

expect(result_set.length).to eq 1
expect(result_set.first.id).to eq '2'

# 5
# update an account
repo = AccountRepository.new
account = repo.find(1)

account.email = 'different@test.com'
account.username = 'different'

repo.update(account)

updated_account = repo.find(1)
expect(updated_account.email).to eq 'different@test.com'
expect(updated_account.username).to eq 'different'

# 6
# Get all posts
repo = PostRepository.new
posts = repo.all
posts.length # =>  2
posts[0].id # =>  1
posts[0].title # =>  'day1'
posts[0].content # =>  'some content'
posts[0].views # => 5
posts[0].account_id # => 1

# 7 
# finds a post
  repo = PostRepository.new
  posts = repo.find(1)
  expect(posts.title).to eq 'day1'
  expect(posts.content).to eq 'some content'
  expect(posts.views).to eq '5'
  expect(posts.account_id).to eq '1'

# 8
# creates a post
repo = PostRepository.new
new_post = Post.new
new_post.title = 'new post'
new_post.content = 'some new content'
new_post.views = '10'
new_post.account_id = '1'

repo.create(new_post) #=> nil

posts = repo.all
last_post = posts.last

expect(last_post.title).to eq 'new post'
expect(last_post.content).to eq 'some new content'
expect(last_post.views).to eq '10'
expect(last_post.account_id).to eq '1'


# 7
# delete a post
repo = PostRepository.new
repo.delete(1)

result_set = repo.all

expect(result_set.length).to eq 1
expect(result_set.first.id).to eq '2'

# 8
# update a post
repo = PostRepository.new
post = repo.find(1)

post.title = 'a new title'
post.content = 'some updated content'

repo.update(post)

updated_post = repo.find(1)
expect(updated_post.title).to eq 'a new title'
expect(updated_post.content).to eq 'some updated content'


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE
# file: spec/account_repository_spec.rb
def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'accounts' })
  connection.exec(seed_sql)
end
describe AccountRepository do
  before(:each) do
    reset_accounts_table
  end
  # (your tests will go here).
end

# file: spec/post_repository_spec.rb
def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'posts' })
  connection.exec(seed_sql)
end
describe PostRepository do
  before(:each) do
    reset_posts_table
  end
  # (your tests will go here).
end

```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
