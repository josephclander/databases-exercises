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