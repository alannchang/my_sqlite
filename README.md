# Welcome to My Sqlite
***

## Task
The assignment was to create a simple SQLite implementation using the Ruby language.  There are two files, my_sqlite_request.rb and my_sqlite_cli.rb, and one handles
building and executing the SQLite query and the other is responsible for CLI (command line interface) behavior for the program.  The program can utilize SELECT,
INSERT, UPDATE, DELETE, FROM, WHERE, and JOIN ON functions from SQLite.

## Description
my_sqlite_request.rb:
A class called MySqliteRequest in my_sqlite_request.rb was used as the foundation for the my_sqlite_request.rb file.  A constructor, along with the various SQLite functions (SELECT,
INSERT, UPDATE, etc.) each have their own class methods.  A 'run' method is also included that executes the SQLite request.

my_sqlite_cli.rb:
The purpose of this file is to create a command-line interface, much like the actual SQLite program, where a user can interact with a SQLite database by entering various 
SQL-like commands and performing operations such as querying data, inserting records, joining tables, updating information, and deleting entries.
A new class called MySqliteCli inherits from the MySqliteRequest class and serves as the backbone for the CLI.

## Installation
If you have the my_sqlite_cli.rb and my_sqlite_request.rb files, you can execute the command-line interface using the 'ruby my_sqlite_cli' command or . 
Examples are provided in the Usage section below.

## Usage
TODO - How does it work?
ruby my_sqlite_request

```
"FROM/SELECT"
# SELECT - SINGLE ARGUMENT AS A STRING
# MySqliteRequest.new.select('*').from('small_test.csv').run
# MySqliteRequest.new.select('FirstName').from('small_test.csv').run

# # SELECT - MULTIPLE ARGUMENTS AS AN ARRAY
# MySqliteRequest.new.select(['Gender', 'Email', 'UserName', 'Device']).from('small_test.csv').run


# "WHERE"
# SINGLE WHERE
# MySqliteRequest.new.select('*').from('small_test.csv').where('Gender', 'Female').run

# MULTIPLE WHERES
# MySqliteRequest.new.select(['Gender', 'LastName', 'UserName', 'Device']).from('small_test.csv').where('Gender', 'Male').where('Device', 'Chrome_Android').run


# "JOIN"
# MySqliteRequest.new.select(['Player', 'height', 'position', 'college']).from('nba_players.csv').join('Player', 'nba_player_data.csv', 'name').run
# MySqliteRequest.new.select("*").from('nba_players.csv').join('Player', 'nba_player_data.csv', 'name').run

# "ORDER"
# ASCENDING
# MySqliteRequest.new.select('*').from('small_test.csv').order(:asc, 'Age').run

# DESCENDING
# MySqliteRequest.new.select('*').from('nba_players.csv').order(:desc, 'born').run


# "INSERT/VALUES"
# request = MySqliteRequest.new.insert('small_test.csv').values({"Gender"=>"Male", "FirstName"=>"John", "LastName"=>"Smith", "UserName"=>"john", "Email"=>"john.smith@aol.com", "Age"=>"90", "City"=>"San_Andreas", "Device"=>"Chrome_Android", "Coffee_Quantity"=>"1", "Order_At"=>"1990-10-25_5:23:51"}).run
# request = request.select('*').run


# "UPDATE/SET"
# request = MySqliteRequest.new.update('small_test.csv').set({"Coffee_Quantity"=>"99", "Age"=>"99"}).where('Gender', 'Male').run
# request = request.select('*').run

# request = MySqliteRequest.new.update('small_test.csv').set({"Age"=>"99"}).run
# request = request.select('*').run


# "DELETE"
# request = MySqliteRequest.new.from('small_test.csv').delete.where('Gender', 'Male').run
# request = request.select('*').run

# request = MySqliteRequest.new.from('small_test.csv').delete.run
# request = request.select('*').run
```

### The Core Team


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>
