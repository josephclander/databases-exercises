# Model class
# (in lib/artist.rb)
class Artist
  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :genre, :albums

  def initialize
    @albums = []
  end
end
