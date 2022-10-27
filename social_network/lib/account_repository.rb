require_relative './account'

class AccountRepository
  def all
    sql = 'SELECT id, email, username FROM accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    accounts = []

    result_set.each do |record|
      account = Account.new
      account.id = record['id']
      account.email = record['email']
      account.username = record['username']
      accounts << account
    end
    accounts
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email, username FROM accounts WHERE id = $1;
    # Returns a single Account object.
    sql = 'SELECT id, email, username FROM accounts WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]
    account = Account.new
    account.id = record['id']
    account.email = record['email']
    account.username = record['username']

    account
  end

  # creates an account
  # with an account object
  def create(account)
    # Executes the SQL query:
    # INSERT INTO accounts (email, username) VALUES ($1, $2);
    sql = 'INSERT INTO accounts (email, username) VALUES ($1, $2);'
    sql_params = [account.email, account.username]
    DatabaseConnection.exec_params(sql, sql_params)

    nil
    # returns nothing
  end

  # delete an account
  # with an account object
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM accounts WHERE id = $1;
    sql = 'DELETE FROM accounts WHERE id = $1;'
    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)

    nil
    # returns nothing
  end

  def update(account)
    sql = 'UPDATE accounts SET email = $1, username = $2 WHERE id = $3'
    sql_params = [account.email, account.username, account.id]

    DatabaseConnection.exec_params(sql, sql_params)

    nil
  end
end
