require_relative './cohort'
require_relative './student'
# Repository class
# (in lib/cohort_repository.rb)
class CohortRepository
  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, cohort_name, start_date FROM cohorts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    cohorts = []
    result_set.each do |record|
      cohort = cohort_build(record)
      cohorts << cohort
    end
    cohorts
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    sql = 'SELECT id, cohort_name, start_date FROM cohorts WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    cohort_build(record)
  end

  # Creates a cohort
  # One argument: Cohort object
  def create(cohort)
    sql = 'INSERT INTO cohorts (cohort_name, start_date) VALUES ($1, $2);'
    sql_params = [cohort.cohort_name, cohort.start_date]
    DatabaseConnection.exec_params(sql, sql_params)

    nil
  end

  # Deletes a Cohort object
  # One argument: id (number)
  def delete(id)
    sql = 'DELETE FROM cohorts WHERE id = $1;'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)

    nil
  end

  # Updates a single Cohort object
  # one argument: cohort object
  def update(cohort)
    sql = 'UPDATE cohorts SET cohort_name = $1, start_date = $2 WHERE id = $3;'
    sql_params = [cohort.cohort_name, cohort.start_date, cohort.id]
    DatabaseConnection.exec_params(sql, sql_params)

    nil
  end

  # Finds a single cohort and its associated students
  # One argument: Cohort id (number)
  def find_with_students(cohort_id)
    sql = 'SELECT cohorts.id AS "id",
      cohorts.cohort_name AS "cohort_name",
      cohorts.start_date AS "start_date",
      students.id AS "student_id",
      students.student_name AS "student_name"
      FROM cohorts
        JOIN students
        ON cohorts.id = students.cohort_id
      WHERE cohort_id = $1'
    sql_params = [cohort_id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)

    first_result = result_set.first

    cohort = cohort_build(first_result)
    students = result_set.map do |record|
      student = Student.new
      student.id = record['student_id']
      student.student_name = record['student_name']
      student
    end
    cohort.students = students
    cohort
  end

  private

  def cohort_build(record)
    cohort = Cohort.new
    cohort.id = record['id']
    cohort.cohort_name = record['cohort_name']
    cohort.start_date = record['start_date']
    cohort
  end
end
