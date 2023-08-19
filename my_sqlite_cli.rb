require './my_sqlite_request.rb'
require "readline"

class MySqliteCli < MySqliteRequest
    attr_reader :full_headers # need list of headers to construct hash for VALUES argument in this CLI
end

puts 'MySQLite version 0.1 20XX-XX-XX'


while cmd_line = Readline.readline("my_sqlite_cli>", true)
    
    if cmd_line.downcase == "quit"
        break

    else
        cmd_arr = cmd_line.chop.split # remove the semi-colon and then put everything into an array

        # find main .csv file (FROM, INSERT, UPDATE)
        if cmd_arr.include?("FROM")
            i_from = cmd_arr.index("FROM")
            query = MySqliteCli.new.from(cmd_arr[i_from + 1])
            cmd_arr.delete_at(i_from + 1) # csv file
            cmd_arr.delete_at(i_from) # "FROM"
            
        elsif cmd_arr.include?("INSERT")
            i_insert = cmd_arr.index("INSERT")
            query = MySqliteCli.new.insert(cmd_arr[i_insert + 2])
            cmd_arr.delete_at(i_insert + 2) # csv file
            cmd_arr.delete_at(i_insert + 1) # "INTO"
            cmd_arr.delete_at(i_insert) # "INSERT"

        elsif cmd_arr.include?("UPDATE")
            i_update = cmd_arr.index("UPDATE")
            query = MySqliteCli.new.update(cmd_arr[i_update + 1])
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

                n = 1
                while cmd_arr[index + n + 3] == 'AND' 
                    column_name = cmd_arr[index + n]
                    criteria = cmd_arr[index + n + 2][1..-2]
                    query = query.where(column_name, criteria)
                    n += 4
                end
                column_name = cmd_arr[index + n]
                criteria = cmd_arr[index + n + 2][1..-2]
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
                    values = [cmd_arr[index + 1][1..-2]]
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
                n = 0
                while cmd_arr[index + n + 3][-1] == ','
                    column = cmd_arr[index + n + 1]
                    value = cmd_arr[index + n + 3][1..-3]
                    data[column] = value
                    n += 3
                end
                column = cmd_arr[index + n + 1]
                value = cmd_arr[index + n + 3][1..-2]
                data[column] = value
                query = query.set(data)
            end
        end

        # after all commands added to query, "run" is executed
        query = query.run do |row, select_headers|
            
            # if 'select' is in the query, the output is changed to resemble the SQLite output format
            selected_values = select_headers.map { |header| row[header] }
            print selected_values.join("|") + "\n"
        end     
    end
end


# TEST CASES HERE

# SELECT Player FROM nba_players.csv;
# SELECT * FROM nba_players.csv;
# SELECT Player, height, weight, born FROM nba_players.csv;

# SELECT * FROM nba_players.csv WHERE birth_state = 'California' AND birth_city = 'Hayward';
# SELECT Player, collage, born, birth_city FROM nba_players.csv WHERE birth_state = 'California';

# SELECT Player, height, position FROM nba_players.csv JOIN nba_player_data.csv ON Player = name;

# SELECT * FROM nba_players.csv ORDER BY Player ASC;
# SELECT * FROM nba_players.csv ORDER BY born DESC;

# INSERT INTO nba_player_data.csv VALUES (Alan_Chang, 2023, 2023, C-F, 5-9, 150, December_25,_2023, Qwasar);

# UPDATE nba_player_data.csv SET height = '7-0', weight = '200' WHERE position = "F-C";

# DELETE FROM nba_player_data.csv WHERE position = 'F';

# DELETE FROM nba_players.csv;
