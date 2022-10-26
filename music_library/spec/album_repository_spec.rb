require 'album_repository'

describe AlbumRepository do
  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before :each do
    reset_albums_table
  end

  it 'returns the list of albums' do
    repo = AlbumRepository.new
    albums = repo.all
    expect(albums.length).to eq 2
    expect(albums.first.id).to eq '1'
    expect(albums.first.title).to eq 'Doolittle'
    expect(albums.first.release_year).to eq '1989'
    expect(albums.first.artist_id).to eq '1'
  end

  it 'returns a single artist' do
    repo = AlbumRepository.new
    album = repo.find(1)
    expect(album.title).to eq 'Doolittle'
    expect(album.release_year).to eq '1989'
    expect(album.artist_id).to eq '1'
  end

  it 'creates a new album' do
    repository = AlbumRepository.new

    album = Album.new
    album.title = 'Trompe le Monde'
    album.release_year = '1991'
    album.artist_id = '1'

    repository.create(album)

    all_albums = repository.all

    expect(all_albums.length).to eq 3
    expect(all_albums.last.title).to eq 'Trompe le Monde'
    expect(all_albums.last.release_year).to eq '1991'
    expect(all_albums.last.artist_id).to eq '1'
  end

  it 'updates an album' do
    repo = AlbumRepository.new

    album = repo.find(1)

    album.title = 'New Title'
    album.release_year = '2022'

    repo.update(album)

    updated_album = repo.find(1)

    expect(updated_album.title).to eq 'New Title'
    expect(updated_album.release_year).to eq '2022'
  end
end
