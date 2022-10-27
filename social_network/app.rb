# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/account_repository'
require_relative 'lib/post_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('social_network')

account_repository = AccountRepository.new
account_repository.all.each do |account|
  p account
end

post_repository = PostRepository.new
post_repository.all.each do |post|
  p post
end
