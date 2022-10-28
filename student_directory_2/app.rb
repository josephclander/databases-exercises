# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/cohort_repository'

DatabaseConnection.connect('student_directory_2')

cohort_repository = CohortRepository.new
cohort2 = cohort_repository.find_with_students(2)

puts "Cohort Name: #{cohort2.cohort_name}"
puts "Start Date: #{cohort2.start_date}"
puts 'Students:'
cohort2.students.each do |student|
  puts "* #{student.student_name}"
end
