# Album Model and Repository Classes Design Recipe

## 1. Design and create the Table

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
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

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES ('Doolittle', '1989', 1);
INSERT INTO albums (title, release_year, artist_id) VALUES ('Waterloo', '1974', 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < spec/seeds_albums.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)

class Album

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, :artist_id
end

```

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: students

# Repository class
# (in lib/student_repository.rb)

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of Student objects.
  end

  # select a single record
  # id argument
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1

    # Returns a single album record
  end

  # Creates a new album record
  # album is an instance of Album
  def create(album)
    # Executes the SQL query:
    # INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2)

    # Returns nothing
  end

  # deletes
  def delete(id)

  end

  def update(album)
    # Executes the SQL query:
    # UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4;

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
# Get all albums

  repo = AlbumRepository.new
  albums = repo.all

  albums.length # => 2
  albums.first.id # => '1'
  albums.first.title # => 'Doolittle'
  albums.first.release_year # => '1989'
  albums.first.artist_id # => '2'


# 2
# Gets a single album record
repo = AlbumRepository.new
album = repo.find(1)
album.title # => 'Doolittle'
album.release_year # => '1989'
album.artist_id # => '2'

# 3
# creates an album record
# repository = AlbumRepository.new

# album = Album.new
# album.title = 'Trompe le Monde'
# album.release_year = 1991
# album.artist_id = 1

# repository.create(album)

# all_albums = repository.all

# The all_albums array should contain the new Album object

# 4
# delete

# 5
# updates an album
repo = AlbumRepository.new

album = repo.find(1)

album.title = 'New Title'
album.release_year = '2022'

repo.update(album)

repo.find(1)

expect(album.title).to eq 'New Title'
expect(album.release_year).to eq '2022'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe AlbumsRepository do
  before(:each) do
    reset_albums_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
