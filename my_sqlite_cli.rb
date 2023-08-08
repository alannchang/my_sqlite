require './my_sqlite_request.rb'
require "readline"

COMMANDS = ["SELECT", "FROM", "WHERE", "JOIN", "ON", "ORDER", "BY", "INSERT", "INTO", "VALUES", "UPDATE", "SET", "DELETE"]

class MySqliteCli < MySqliteRequest
end


while cmd_line = Readline.readline("my_sqlite_cli>", true)
    
    if cmd_line.downcase == "quit"
        break
    else
        cmd_arr = cmd_line.split
        # find main .csv file
        if cmd_arr.include?("FROM")
            i_from = cmd_arr.index("FROM")
            query = MySqliteCli.new.from(cmd_arr[i_from + 1])
            cmd_arr.delete_at(i_from)
            cmd_arr.delete_at(i_from + 1)
        elsif cmd_arr.include?("INSERT")
            i_insert = cmd_arr.index("INSERT")
            query = MySqliteCli.new.insert(cmd_arr[i_insert + 2])
            cmd_arr.delete_at(i_insert)
            cmd_arr.delete_at(i_insert + 1)
            cmd_arr.delete_at(i_insert + 2)
        elsif cmd_arr.include?("UPDATE")
            i_update = cmd_arr.index("UPDATE")
            query = MySqliteCli.new.update(cmd_arr[i_update + 1])
            cmd_arr.delete_at(i_update)
            cmd_arr.delete_at(i_update + 1)
        end

        cmd_arr.each_with_index do |element, index|
            if element == "SELECT"
                if cmd_arr[index + 1] == "*"
                    query = query.select('*')
                end
            end
        end

        query = query.run do |row|
            row.each_with_index do |(key, value), index|
              print "#{value}"
              print "|" if index < row.length - 1
            end
            print "\n"
          end
            



    end

end

# TEST CASES HERE

# SELECT * FROM small_test.csv;
# SELECT FirstName FROM small_test.csv;
# SELECT Gender, Email, UserName, Device FROM small_test.csv;

# SELECT * FROM small_test.csv WHERE FirstName = 'Carl';
# SELECT Gender, LastName, UserName, Age FROM small_test.csv WHERE Device = 'Chrome Android';

# SELECT Player, height, position FROM nba_players.csv JOIN nba_players.csv ON Player = name;

# SELECT * FROM small_test.csv ORDER BY Age ASC;
# SELECT * FROM nba_players.csv ORDER BY born DESC;

# INSERT INTO small_test.csv VALUES Gender = 'Male', FirstName = 'John', LastName = 'Smith', UserName = 'john', Email = 'john.smith.aol.com', Age = '90', City = 'San Andreas', Device = 'Chrome Android', Coffee Quantity = '1', Order At = '1990-10-25 5:23:51';

# UPDATE small_test.csv SET Coffee Quantity = '99' WHERE Gender = "Male";

# DELETE FROM small_test.csv WHERE Gender = 'Female' AND Age = '21';