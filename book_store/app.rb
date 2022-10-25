# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/book_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('book_store')

# Print out each record from the result set .

book_repository = BookRepository.new

book_repository.all.each do |book|
  p book
end
