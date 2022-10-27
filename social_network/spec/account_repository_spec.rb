# file: spec/account_repository_spec.rb
require 'account_repository'

describe AccountRepository do
  def reset_accounts_table
    seed_sql = File.read('spec/seeds_accounts.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_accounts_table
  end

  it 'returns a list of accounts' do
    repo = AccountRepository.new
    accounts = repo.all
    expect(accounts.length).to eq 2
    expect(accounts[0].id).to eq '1'
    expect(accounts[0].email).to eq 'joe@test.com'
    expect(accounts[0].username).to eq 'joelander'

    expect(accounts[1].id).to eq '2'
    expect(accounts[1].username).to eq 'iainhoolahan'
    expect(accounts[1].email).to eq 'iain@test.com'
  end

  it 'finds a single account' do
    repo = AccountRepository.new
    accounts = repo.find(1)
    expect(accounts.id).to eq '1'
    expect(accounts.username).to eq 'joelander'
    expect(accounts.email).to eq 'joe@test.com'
  end

  it 'creates an account' do
    repo = AccountRepository.new
    new_account = Account.new
    new_account.email = 'adon@test.com'
    new_account.username = 'adonlawley'

    repo.create(new_account)

    accounts = repo.all
    last_account = accounts.last

    expect(last_account.email).to eq 'adon@test.com'
    expect(last_account.username).to eq 'adonlawley'
  end

  it 'deletes an account' do
    repo = AccountRepository.new
    repo.delete(1)

    result_set = repo.all

    expect(result_set.length).to eq 1
    expect(result_set.first.id).to eq '2'
  end

  it 'updates an account' do
    repo = AccountRepository.new
    account = repo.find(1)

    account.email = 'different@test.com'
    account.username = 'different'

    repo.update(account)

    updated_account = repo.find(1)
    expect(updated_account.email).to eq 'different@test.com'
    expect(updated_account.username).to eq 'different'
  end
end
