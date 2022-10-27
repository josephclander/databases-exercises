# file: app.rb

require_relative './lib/album_repository'
require_relative './lib/artist_repository'

# The Application class initializer
class Application
  # takes four arguments:
  #  * The database name to call `DatabaseConnection.connect`
  #  * the Kernel object as `io` (so we can mock the IO in our tests)
  #  * the AlbumRepository object (or a double of it)
  #  * the ArtistRepository object (or a double of it)
  def initialize(database_name, io, album_repository, artist_repository)
    DatabaseConnection.connect(database_name)
    @io = io
    @album_repository = album_repository
    @artist_repository = artist_repository
  end

  def run
    # "Runs" the terminal application
    # so it can ask the user to enter some input
    # and then decide to run the appropriate action
    # or behaviour.
    @io.puts 'Welcome to the music library manager!\n'
    @io.puts 'What would you like to do?'
    @io.puts '1 - List all albums'
    @io.puts '2 - List all artists'
    @io.puts 'Enter your choice: '
    input = @io.gets.chomp
    if input == '1'
      @io.puts "\nHere is the list of albums:"
      @album_repository.all.each do |album|
        @io.puts "* #{album.id} - #{album.title}"
      end
    end
    if input == '2'
      @io.puts "\nHere is the list of artists:"
      @artist_repository.all.each do |artist|
        @io.puts "* #{artist.id} - #{artist.name}"
      end
    end
    # Use `@io.puts` or `@io.gets` to
    # write output and ask for user input.
  end
end

# Don't worry too much about this if statement. It is basically saying "only
# run the following code if this is the main file being run, instead of having
# been required or loaded by another file.
# If you want to learn more about __FILE__ and $0, see here: https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#Pre-defined_Variables
if __FILE__ == $0
  app = Application.new(
    'music_library',
    Kernel,
    AlbumRepository.new,
    ArtistRepository.new
  )
  app.run
end
