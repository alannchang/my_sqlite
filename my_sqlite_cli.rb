require './my_sqlite_request.rb'
require "readline"

=begin
Create a program which will be a Command Line Interface (CLI) to your MySqlite class.
It will use readline and we will run it with ruby my_sqlite_cli.rb
=end

while buf = Readline.readline("my_sqlite_cli>", true)
    p buf
end