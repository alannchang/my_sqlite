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
Using the my_sqlite_cli.rb and my_sqlite_request.rb files, you can execute queries in the command line using the 'ruby my_sqlite_cli.rb' command or you can build and execute requests
in Ruby by appending it to the end of the my_sqlite_request.rb file and then running the 'ruby my_sqlite_request.rb' command.

## Usage
Test cases are provided at the end of each file as comments.

my_sqlite_request:
Test cases can be run by "uncommenting" the test case at the end of the file and running the "ruby my_sqlite_request" command in the terminal. 

my_sqlite_cli:
A set of example test cases can be located at the end of the my_sqlite_cli.rb file and can be copy/pasted into the terminal.
Test cases can be run directly in the terminal like so:
```
ruby my_sqlite_cli.rb

SELECT * FROM nba_players.csv;
```
SQLite queries must end with a semi-colon.
To exit the CLI, the 'quit' command will close the program. 

### The Core Team


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>
