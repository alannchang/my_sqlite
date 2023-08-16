require './my_sqlite_request.rb'
require "readline"

COMMANDS = ["SELECT", "FROM", "WHERE", "JOIN", "ON", "ORDER", "BY", "INSERT", "INTO", "VALUES", "UPDATE", "SET", "DELETE"]

class MySqliteCli < MySqliteRequest
    attr_reader :full_headers # need list of headers to construct hash for VALUES argument in this CLI
end


query = nil

puts 'MySQLite version 0.1 20XX-XX-XX'

while cmd_line = Readline.readline("my_sqlite_cli>", true)
    
    if cmd_line.downcase == "quit"
        break

    else
        cmd_arr = cmd_line.chop.split

        # find main .csv file (FROM, INSERT, UPDATE)
        if cmd_arr.include?("FROM")
            i_from = cmd_arr.index("FROM")
            if query == nil
                query = MySqliteCli.new.from(cmd_arr[i_from + 1])
            else 
                query = query.from(cmd_arr[i_from + 1])
            end
            cmd_arr.delete_at(i_from + 1) # csv file
            cmd_arr.delete_at(i_from) # "FROM"
            
        elsif cmd_arr.include?("INSERT")
            i_insert = cmd_arr.index("INSERT")
            if query == nil
                query = MySqliteCli.new.insert(cmd_arr[i_insert + 2])
            else
                query = query.insert(cmd_arr[i_insert + 2])
            end
            cmd_arr.delete_at(i_insert + 2) # csv file
            cmd_arr.delete_at(i_insert + 1) # "INTO"
            cmd_arr.delete_at(i_insert) # "INSERT"

        elsif cmd_arr.include?("UPDATE")
            i_update = cmd_arr.index("UPDATE")
            if query == nil
                query = MySqliteCli.new.update(cmd_arr[i_update + 1])
            else
                query = query.update(cmd_arr[i_update + 1])
            end
            cmd_arr.delete_at(i_update + 1) # csv file
            cmd_arr.delete_at(i_update) # "UPDATE"

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
                        headers << cmd_arr[index + n].chop
                        n += 1
                    end
                    headers << cmd_arr[index + n]
                    
                    query = query.select(headers)
                end
            
            when "WHERE"
                column_name = cmd_arr[index + 1]
                criteria = cmd_arr[index + 3][1..-2]
                query = query.where(column_name, criteria)
            when "JOIN"
                db2 = cmd_arr[index + 1]
                column_a = cmd_arr[index + 3]
                column_b = cmd_arr[index + 5]
                query = query.join(column_a, db2, column_b)

            when "ORDER"
                column = cmd_arr[index + 2]
                if cmd_arr[index + 3] == 'ASC'
                    query = query.order(:asc, column)
                else
                    query = query.order(:desc, column)
                end

            when "VALUES"
                if cmd_arr[index + 1][0] == "("
                    values = [cmd_arr[index + 1][1..-2]] # first string minus parenthesis and comma
                    n = 1
                    while cmd_arr[index + n][-1] != ")"
                        n += 1
                        values << cmd_arr[index + n][0..-2]
                    end
                    args = query.full_headers.zip(values).to_h
                    query = query.values(args)
                end

            when "SET"
                data = {}
                column = cmd_arr[index + 1]
                value = cmd_arr[index + 3][1..-2]
                data[column] = value
                query = query.set(data)
            end
        end

        query = query.run do |row, select_headers|
            selected_values = select_headers.map { |header| row[header] }
            print selected_values.join("|") + "\n"
        end
            
    end

end

# TEST CASES HERE

# SELECT Player FROM nba_players.csv;
# SELECT * FROM nba_players.csv;
# SELECT Player, height, weight, born FROM nba_players.csv;

# SELECT * FROM nba_players.csv WHERE birth_state = 'California';
# SELECT Player, collage, born, birth_city FROM nba_players.csv WHERE birth_state = 'California';

# SELECT Player, height, position FROM nba_players.csv JOIN nba_player_data.csv ON Player = name;

# SELECT * FROM nba_players.csv ORDER BY Player ASC;
# SELECT * FROM nba_players.csv ORDER BY born DESC;

# INSERT INTO small_test.csv VALUES (Male, John, Smith, john, john.smith.aol.com, 90, San_Andreas, Chrome_Android, 1, 1990-10-25_5:23:51);

# UPDATE small_test.csv SET Coffee_Quantity = '99' WHERE Gender = "Male";

# DELETE FROM small_test.csv WHERE Gender = 'Female' AND Age = '21';
