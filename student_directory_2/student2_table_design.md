# Two Tables Design

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a coach
So I can get to know all [students]
I want to see a list of students' [names].

As a coach
So I can get to know all students
I want to see a list of [cohorts'] [names].

As a coach
So I can get to know all students
I want to see a list of cohorts' [starting dates].

As a coach
So I can get to know all students
I want to see a list of students' [cohorts].
```

```
Nouns:

cohorts: name, start_date
students: name, cohort
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record           | Properties         |
| -----------------| ------------------ |
| cohort           | name, start_date   |
| student          | name, cohort       |

1. Name of the first table (always plural): `cohorts` 

    Column names: `name`, `start_date`

2. Name of the second table (always plural): `students` 

    Column names: `name`, cohort_id

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: cohorts
id: SERIAL
cohort_name: text
start_date: date

Table: students
id: SERIAL
student_name: text
cohort_id: int
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

You'll then be able to say that:

1. **[A] has many [B]**
2. And on the other side, **[B] belongs to [A]**
3. In that case, the foreign key is in the table [B]

Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one `cohort` have many `students`? YES
2. Can one `student` have many `cohorts`? NO

-> Therefore,
-> An cohort HAS MANY students
-> An student BELONGS TO a cohort

-> Therefore, the foreign key is on the albums table.
```

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: cohorts_table.sql
-- file: students_table.sql

-- Replace the table name, columm names and types.

-- Create the table without the foreign key first.
CREATE TABLE cohorts (
  id SERIAL PRIMARY KEY,
  cohort_name text,
  start_date date
);

-- Then the table with the foreign key.
CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  student_name text,
-- The foreign key name is always {other_table_singular}_id
  cohort_id int,
  constraint fk_cohort foreign key(cohort_id)
    references cohorts(id)
    on delete cascade
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 student_directory_2 < cohorts_table.sql
psql -h 127.0.0.1 student_directory_2 < students_table.sql
```
