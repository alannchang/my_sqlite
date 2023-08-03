require './my_sqlite_request.rb'
require "readline"

while cmd_line = Readline.readline("my_sqlite_cli>", true)
    
    if cmd_line.downcase == "quit"
        break
    else
        cmd_line_split = cmd_line.split
        
        cmd_line_split.each do |cmd|
            case cmd
            when "select"
                puts "select baby!"




        puts cmd_line_split # TEST PRINT
    end

end