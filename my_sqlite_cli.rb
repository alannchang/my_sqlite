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
        
        # find main .csv file (FROM, INSERT, UPDATE)
        if cmd_arr.include?("FROM")
            i_from = cmd_arr.index("FROM")
            query = MySqliteCli.new.from(cmd_arr[i_from + 1])
            cmd_arr.delete_at(i_from) # "FROM"
            cmd_arr.delete_at(i_from + 1) # csv file
        elsif cmd_arr.include?("INSERT")
            i_insert = cmd_arr.index("INSERT")
            query = MySqliteCli.new.insert(cmd_arr[i_insert + 2])
            cmd_arr.delete_at(i_insert) # "INSERT"
            cmd_arr.delete_at(i_insert + 1) # "INTO"
            cmd_arr.delete_at(i_insert + 2) # csv file
        elsif cmd_arr.include?("UPDATE")
            i_update = cmd_arr.index("UPDATE")
            query = MySqliteCli.new.update(cmd_arr[i_update + 1])
            cmd_arr.delete_at(i_update) # "UPDATE"
            cmd_arr.delete_at(i_update + 1) # csv file
        end

        # everything else (SELECT, WHERE, JOIN, ORDER, VALUES, SET, DELETE)
        cmd_arr.each_with_index do |element, index|
            case element
            when "DELETE"
                query = query.delete
            when "SELECT"
                if cmd_arr[index + 1] == "*"
                    query = query.select("*")
                else
                    headers = []
                    n = 1
                    while cmd_arr[index + n].end_with?(",")
                        headers << cmd_arr[index + n]
                        n += 1
                    end
                    headers << cmd_arr[index + n]
                    query = query.select(headers)
                end



            when "WHERE"
            when "JOIN"
            when "ORDER"
            when "VALUES"
            when "SET"
            end
        end

        query = query.run do |row, select_headers|
            selected_values = select_headers.map { |header| row[header] }
            print selected_values.join("|") + "\n"
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