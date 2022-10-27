# frozen_string_literal: false

require_relative '../app'

describe Application do
  def reset_tables
    seed_sql = File.read('spec/seeds_app.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before :each do
    reset_tables
  end

  context 'given the user selects "1 = List all albums"' do
    it 'returns a list of albums' do
      terminal = double :terminal
      expect(terminal).to receive(:puts).with('Welcome to the music library manager!\n').ordered
      expect(terminal).to receive(:puts).with('What would you like to do?').ordered
      expect(terminal).to receive(:puts).with('1 - List all albums').ordered
      expect(terminal).to receive(:puts).with('2 - List all artists').ordered
      expect(terminal).to receive(:puts).with('Enter your choice: ').ordered
      expect(terminal).to receive(:gets).and_return('1').ordered
      expect(terminal).to receive(:puts).with("\nHere is the list of albums:").ordered
      expect(terminal).to receive(:puts).with('* 1 - Doolittle').ordered
      expect(terminal).to receive(:puts).with('* 2 - Surfer Rosa').ordered
      expect(terminal).to receive(:puts).with('* 3 - Waterloo').ordered
      expect(terminal).to receive(:puts).with('* 4 - Super Trouper').ordered
      expect(terminal).to receive(:puts).with('* 5 - Bossanova').ordered
      expect(terminal).to receive(:puts).with('* 6 - Lover').ordered
      expect(terminal).to receive(:puts).with('* 7 - Folklore').ordered
      expect(terminal).to receive(:puts).with('* 8 - I Put a Spell on You').ordered
      expect(terminal).to receive(:puts).with('* 9 - Baltimore').ordered
      expect(terminal).to receive(:puts).with("* 10 -\sHere Comes the Sun").ordered
      expect(terminal).to receive(:puts).with("* 11 -\sFodder on My Wings").ordered
      expect(terminal).to receive(:puts).with("* 12 -\sRing Ring").ordered

      album_repository = AlbumRepository.new
      artist_repository = ArtistRepository.new
      app = Application.new('music_library_test', terminal, album_repository, artist_repository)
      app.run
    end
  end
  
  context 'given the user selects "2 = List all artists"' do
    it 'returns a list of artists' do
      terminal = double :terminal
      expect(terminal).to receive(:puts).with('Welcome to the music library manager!\n').ordered
      expect(terminal).to receive(:puts).with('What would you like to do?').ordered
      expect(terminal).to receive(:puts).with('1 - List all albums').ordered
      expect(terminal).to receive(:puts).with('2 - List all artists').ordered
      expect(terminal).to receive(:puts).with('Enter your choice: ').ordered
      expect(terminal).to receive(:gets).and_return('2').ordered
      expect(terminal).to receive(:puts).with("\nHere is the list of artists:").ordered
      expect(terminal).to receive(:puts).with('* 1 - Pixies').ordered
      expect(terminal).to receive(:puts).with('* 2 - ABBA').ordered
      expect(terminal).to receive(:puts).with('* 3 - Taylor Swift').ordered
      expect(terminal).to receive(:puts).with('* 4 - Nina Simone').ordered

      album_repository = AlbumRepository.new
      artist_repository = ArtistRepository.new
      app = Application.new('music_library_test', terminal, album_repository, artist_repository)
      app.run
    end
  end
end

# $ ruby app.rb

# Welcome to the music library manager!

# What would you like to do?
#  1 - List all albums
#  2 - List all artists

# Enter your choice: 1
# [ENTER]

# Here is the list of albums:
#  * 1 - Doolittle
#  * 2 - Surfer Rosa
#  * 3 - Waterloo
#  * 4 - Super Trouper
#  * 5 - Bossanova
#  * 6 - Lover
#  * 7 - Folklore
#  * 8 - I Put a Spell on You
#  * 9 - Baltimore
#  * 10 -	Here Comes the Sun
#  * 11 - Fodder on My Wings
#  * 12 -	Ring Ring
