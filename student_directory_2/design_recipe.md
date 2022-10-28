# Cohort Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._
<!-- 
## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
``` -->

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_cohorts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE cohorts, students RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO cohorts (cohort_name, start_date) VALUES ('ruby', '2022-10-01');
INSERT INTO cohorts (cohort_name, start_date) VALUES ('javascript', '2022-09-01');
INSERT INTO students (student_name, cohort_id) VALUES ('Joe', 1);
INSERT INTO students (student_name, cohort_id) VALUES ('Paul', 1);
INSERT INTO students (student_name, cohort_id) VALUES ('Ellie', 2);
INSERT INTO students (student_name, cohort_id) VALUES ('Mark', 2);
INSERT INTO students (student_name, cohort_id) VALUES ('Bhavik', 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 student_directory_2 < seeds_cohorts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)
class Student
end

# Model class
# (in lib/cohott.rb)
class Cohort
end

# Repository class
# (in lib/cohort_repository.rb)
class CohortRepository

end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)
class Student
# Replace the attributes by your own columns.
attr_accessor :id, :student_name, :cohort_id
end

# Model class
# (in lib/cohort.rb)
class Cohort
attr_accessor :id, :cohort_name, :start_date

  def initialize
    @students = []
  end
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: cohorts

# Repository class
# (in lib/cohort_repository.rb)
class CohortRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, cohort_name, start_date FROM cohorts;

    # Returns an array of Cohort objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, cohort_name, start_date FROM cohorts WHERE id = $1;

    # Returns a single Cohort object.
  end

  # Creates a cohort
  # One argument: Cohort object
  def create(cohort)
  # INSERT INTO cohorts (cohort_name, start_date) VALUES ($1, $2);

  # returns nil
  end

  # Updates a Cohort object
  # One argument: Cohort object
  def update(cohort)
  # UPDATE SET cohort_name = $1, start_date = $2 WHERE id = $3;

  # returns nil
  end

  # Deletes a Cohort object
  # One argument: id (number)
  def delete(id)
  # DELETE FROM cohorts WHERE id = $1;

  # returns nil
  end

  # Updates a single Cohort object
  # one argument: cohort object
  def update(cohort)
    # UPDATE cohorts SET cohort_name = $1, start_date = $2 WHERE id = $3;

    # returns nil
  end

  # Finds a single cohort and its associated students
  # One argument: Cohort id (number)
  def find_with_students(id)
    # SELECT cohorts.cohort_name AS "cohort_name",
            # cohorts.start_date AS "start_date",
            # students.id AS "student_id",
            # students.student_name AS "student_name"
    # FROM cohorts
    # 	JOIN students
    # 	ON cohorts.id = students.cohort_id
    # WHERE cohort_id = $1

    # returns a Cohort object
    # with the array of Student objects
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all cohorts

repo = CohortRepository.new

cohorts = repo.all

cohorts.length # =>  2

cohorts[0].id # =>  1
cohorts[0].cohort_name # =>  'ruby'
cohorts[0].start_date # =>  'Oct 2022'

cohorts[1].id # =>  2
cohorts[1].cohort_name # =>  'javascript'
cohorts[1].start_date # =>  'Sept 2022'

# 2
# Get a single cohort
repo = CohortRepository.new

cohort = repo.find(1)

cohort.id # =>  1
cohort.cohort_name # =>  'ruby'
cohort.start_date # =>  '2022-10-01'

# 3
# create a cohort
repo = CohortRepository.new

cohort = Cohort.new
cohort.cohort_name = 'C++'
cohort.start_date = 'Jan 2022'

repo.create(cohort)

# we have two cohorts to start
# so it will be the 3rd
new_cohort = repo.find(3)

new_cohort.cohort_name # => 'C++'
new_cohort.start_date # => '2022-01-01'

# 4
# delete a cohort
repo = CohortRepository.new
repo.delete(1)

repo.all
repo.length # => 1
repo.first.id # => 2

# 5
# updates a cohort
repo = CohortRepository.new
cohort = repo.find(1)

cohort.cohort_name = 'new name'
cohort.start_date =  '2023-12-01'

repo.update(cohort)

repo.find(1)

cohort.cohort_name # =>  'new name'
cohort.start_date # =>  '2023-12-01'

# 6
# finds a single cohort and all its students
repo = CohortRepository.new
cohort = repo.find_with_students(1)
cohort.cohort_name # => 'ruby'
cohort.students.length # => '2'
cohort.students.first.student_name # => 'Joe'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/cohort_repository_spec.rb

def reset_cohorts_table
  seed_sql = File.read('spec/seeds_cohorts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'student_directory_2' })
  connection.exec(seed_sql)
end

describe CohortRepository do
  before(:each) do 
    reset_cohorts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
